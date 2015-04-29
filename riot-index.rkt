#lang racket

(require 
     racket/gui/base
     net/url
     json
     racket/format
     web-server/servlet
     web-server/servlet-env
     web-server/templates
     xml
)

; Query API for general player information
(define api-request "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/SUMMONER_NAME?api_key=8864143b-a987-45a8-b49d-53c0a7677100")

; The main procedure for getting general player info
(define (query-for-summoner name)
  (define summoner-request (string->url (string-replace api-request "SUMMONER_NAME" name)))
  (define (fix-name name)
    (string-replace (string-downcase name) " " ""))
  
  ; Define request parameters, setup for output
  (define sh (get-pure-port summoner-request #:redirections 5))
  (define summoner-hash-str (port->string sh))
  (define summoner-hash-json (string->jsexpr summoner-hash-str))
  (close-input-port sh)

  ; Defining the first hash table, with the player's name, Id, profile icon id and level
  (define summoner (hash-ref summoner-hash-json (string->symbol (fix-name name))))

  (define summoner-id    (hash-ref summoner 'id))
  (define summoner-name  (hash-ref summoner 'name))
  (define summoner-icon  (hash-ref summoner 'profileIconId))
  (define summoner-level (hash-ref summoner 'summonerLevel))
  
  ;Needed to display feeder score
  (define fsphrase "Feeder Score: ")
  (define phrase "This person is ")
  
  (define orange "badge-warning")
  
  
  ; Get information for their overall ranked stats
  (define api-id-request "https://na.api.pvp.net/api/lol/na/v1.3/stats/by-summoner/SUMMONER_ID/ranked?api_key=8864143b-a987-45a8-b49d-53c0a7677100")
  (define (query-for-id id)
    (define ranked-stats (string->url (string-replace api-id-request "SUMMONER_ID" (number->string summoner-id))))
    
    ; Define request parameters for RANKED-STATS, setup for output
    (define ranked (get-pure-port ranked-stats #:redirections 5))
    (define ranked-hash-str (port->string ranked))
    (define ranked-hash-json (string->jsexpr ranked-hash-str))
    
    ; Define the hash-table with information about all of their champion's combined data
    (define ranked-champ-id (hash-ref ranked-hash-json 'champions))
    
    ; A for/or loop in order to fine the id = 0 key, which has information for all champion stats combined
    (define ranked-all-stats  
      (for/or ([champ (in-list ranked-champ-id)])
        (cond [(= 0 (hash-ref champ 'id)) champ]
              [else #f])))

    ; Specific stats(games played, won, lost) as well as the formulas for KDA and custom made "feeder-score"
    (define ranked-played (hash-ref (hash-ref ranked-all-stats 'stats) 'totalSessionsPlayed))
    (define ranked-won (hash-ref (hash-ref ranked-all-stats 'stats) 'totalSessionsWon))
    (define ranked-lost (hash-ref (hash-ref ranked-all-stats 'stats) 'totalSessionsLost))
    (define ranked-win-loss (/ ranked-won ranked-played))
    (define ranked-kills (hash-ref (hash-ref ranked-all-stats 'stats) 'totalChampionKills))
    (define ranked-deaths (hash-ref (hash-ref ranked-all-stats 'stats) 'totalDeathsPerSession))
    (define ranked-assists (hash-ref (hash-ref ranked-all-stats 'stats) 'totalAssists))
    (define feeder-score 
      (let ([x (truncate (* 10 (+ (/ (+ ranked-kills ranked-assists) ranked-deaths) (exact->inexact ranked-win-loss))))])
        (define feeds "<br />This person is likely to feed. dodge pls")
        (define ave "<br />This person is average.  Good luck.")
        (define carry "<br />This person is likely to carry. don't feed nerd.")
        (cond [(< x 25)
               (string-append fsphrase (number->string x)
                              feeds)]
               [(and (> x 25) (< x 40))
               (string-append fsphrase (number->string x)
                              ave)]
               [(> x 40)
               (string-append fsphrase (number->string x)
                              carry)])))  
  
  
    ; Get information regarding their League placement(specific ranking in the ladder)
    (define api-league-request "https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/SUMMONER_ID/?api_key=8864143b-a987-45a8-b49d-53c0a7677100")
    (define (query-for-league league)
      
      ; Define request parameters for LEAGUE-STATS, setup for output
      (define league-stats (string->url (string-replace api-league-request "SUMMONER_ID" (number->string summoner-id))))
      (define league (get-pure-port league-stats #:redirections 5))
      (define league-hash-str (port->string league))
      (define league-hash-json (string->jsexpr league-hash-str))
      
    ; Get the league id hash by using the summoner-id as a key
      (define league-id (hash-ref league-hash-json (string->symbol (number->string summoner-id))))  
      (define league-tier (hash-ref (car league-id) 'tier))
      (define league-entries (hash-ref (car league-id) 'entries))
      
      ; Another for/or loop to find the specific player in the league table
      (define league-player 
        (for/or ([player (in-list league-entries)])
        (cond [(string=? (number->string summoner-id) (hash-ref player 'playerOrTeamId)) player]
              [else #f])))
      
      ; League-related stas, such as division, wins, losses, LP(point system) and league win/loss for soloqueue
      (define league-division (hash-ref league-player 'division))
      (define league-wins (hash-ref league-player 'wins))
      (define league-losses (hash-ref league-player 'losses))
      (define league-points (hash-ref league-player 'leaguePoints))
      (define league-win-loss (truncate (* 100 (/ league-wins (+ league-wins league-losses)))))
      
      
      ;make webpage
      (define (start req)
        (response/xexpr
         `(html
           ,(make-cdata #f #f
                        (let ([title "Will They Feed?"]
                              [id summoner-id]
                              [name summoner-name]
                              [icon summoner-icon]
                              [level summoner-level]
                              [tier league-tier]
                              [division league-division]
                              [soloqwins league-wins]
                              [soloqlosses league-losses]
                              [soloqpoints league-points]
                              [soloqwl league-win-loss]
                              [rankedgames ranked-played ]
                              [rankedwins ranked-won]
                              [rankedlosses ranked-lost]
                              [kills ranked-kills]
                              [deaths ranked-deaths]
                              [assists ranked-assists]
                              [feederscore feeder-score ]
                              
                              )
                          (include-template "index.html")
                          )
                        )
           )
         )
        )
      
      (serve/servlet start)
      )
  (query-for-league summoner-id))
  (query-for-id summoner-id))

    
  ; Query the API for all the stats

; --- GUI window for testing
(define frame (new frame% 
     [label "Will They Feed: a Statistics Tracker"]
     [width 400]
     [height 100]))

(send frame show #t)

(define msg (new message%
     [parent frame]
     [label "Welcome to WILL. THEY. FEEEEEEEEED?!?!?!?!\nExample players: Dyrus, Raker, Forcinit\nPick any ranked League of Legends summoner,\nand we'll show you their stats."]))

(define sn-input (new text-field% 
     [parent frame]
     [label "Summoner Name: "]
     [init-value ""]
     [callback (lambda(f ev)
                 (send f get-value))
                 ]))

(define submit-button (new button% 
     [parent frame]
     [label "Will They Feed?"]
     [callback (lambda (button event)
                 (let ([v (send sn-input get-value)])
                   (query-for-summoner v))
                 (send msg set-label "Closing program..."))]))

