Welcome to our OPL Project, Will They Feed!

Josh:
I've gotten most of the parsing to work, having trouble with a particularly nasty hash-table-in-a-hash-table-in-a-hash-table (hashseption) but I have it working so entering a summoner name will sanitize it, pass it to the api, then pull out certain stats(still waiting on a stack overflow answer to get league-division and league-tier) and print them out.

To use it - simply type a summoner name after running the racket file.  If you don't know any summoner names, try "raker" or "forcinit".  The inputs are checked so even if the capitalization or spacing it wrong, it will still get you the right information (ex. 'FORCIN it' and 'forC init' and 'forcinit' all correctly display the summoner information for 'F O R C I N it')

```
#lang racket

(require 
     racket/gui/base
     net/url
     json
     racket/format
)

; --- Query API
(define api-request "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/SUMMONER_NAME?api_key=8864143b-a987-45a8-b49d-53c0a7677100")
(define (query-for-summoner name)
  (define summoner-request (string->url (string-replace api-request "SUMMONER_NAME" name)))

  
  (define (fix-name name)
    (string-replace (string-downcase name) " " ""))
  
  
  
 
  
  
  
  
  
  ; Define request parameters, setup for output
  (define sh (get-pure-port summoner-request #:redirections 5))
  (define summoner-hash-str (port->string sh))
  (define summoner-hash-json (string->jsexpr summoner-hash-str))
  (close-input-port sh)


  (define summoner (hash-ref summoner-hash-json (string->symbol (fix-name name))))

  (define summoner-id    (hash-ref summoner 'id))
  (define summoner-name  (hash-ref summoner 'name))
  (define summoner-icon  (hash-ref summoner 'profileIconId))
  (define summoner-level (hash-ref summoner 'summonerLevel))
  
  
  
  
    (printf "Results for: ~a\n" summoner-name)
  (printf "- ID: ~a\n" summoner-id)
  (printf "- Icon ID: ~a\n" summoner-icon)
  (printf "- Level: ~a\n" summoner-level)
  
  (define api-id-request "https://na.api.pvp.net/api/lol/na/v1.3/stats/by-summoner/SUMMONER_ID/ranked?api_key=8864143b-a987-45a8-b49d-53c0a7677100")
  (define (query-for-id id)
    (define ranked-stats (string->url (string-append (string-append "https://na.api.pvp.net/api/lol/na/v1.3/stats/by-summoner/" (number->string summoner-id)) "/ranked?api_key=8864143b-a987-45a8-b49d-53c0a7677100")))

    ; Define request parameters for RANKED-STATS, setup for output
    (define ranked (get-pure-port ranked-stats #:redirections 5))
    (define ranked-hash-str (port->string ranked))
    (define ranked-hash-json (string->jsexpr ranked-hash-str))
    
    (define ranked-champ-id (hash-ref ranked-hash-json 'champions))
    (define ranked-all-stats  
      (for/or ([champ (in-list ranked-champ-id)])
        (cond [(= 0 (hash-ref champ 'id)) champ]
              [else #f])))

    (define ranked-played (hash-ref (hash-ref ranked-all-stats 'stats) 'totalSessionsPlayed))
    (define ranked-won (hash-ref (hash-ref ranked-all-stats 'stats) 'totalSessionsWon))
    (define ranked-lost (hash-ref (hash-ref ranked-all-stats 'stats) 'totalSessionsLost))
    (define ranked-win-loss (/ ranked-won ranked-played))
  
    (printf "- Total Ranked Matches: ~a\n" ranked-played)
    (printf "- Total Ranked Wins: ~a\n" ranked-won)
    (printf "- Total Ranked Losses: ~a\n" ranked-lost)
    (printf "- Total Win-Ratio: ~a%\n" (truncate (* 100 ranked-win-loss)))

    )
  ;(define api-league-request "https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/SUMMONER_ID/?api_key=8864143b-a987-45a8-b49d-53c0a7677100")
  ;(define (query-for-league league)
    ;(define league-stats (string->url (string-append (string-append "https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/" (number->string summoner-id)) "/?api_key=8864143b-a987-45a8-b49d-53c0a7677100")))
    ;
    ;(define league (get-pure-port league-stats #:redirections 5))
    ;(define league-hash-str (port->string league))
    ;(define league-hash-json (string->jsexpr league-hash-str))
    ; 
    ;vvvvv doesn't work; the first key in the hash is a number which is always equal to summoner-id, but it says the key doesn't exist.
    ;when I tried to debug it using hash->list, it tells me the first key is the same thing as summoner-id, but with vertical bars on either side ex. |26055765|
    ;(define league-id (hash-ref league-hash-json summoner-id))
    ;(define league-tier (hash-ref league-id 'tier))
    ;(define league-entries (hash-ref league-id 'entries))
    ;(define league-player  
    ;  (for/or ([id (in-list league-entries)])
    ;    (cond [(= summoner-id (hash-ref id 'playerOrTeamId)) id]
    ;          [else #f])))
    ;
    ;(define league-division (hash-ref league-player 'division))
    ;
    ;(printf "- Ranking: ~a ~a\n" league-tier league-division)
    ;)
      (query-for-id summoner-id)
  ;(query-for-league summoner-id)
  )

; --- Build Frame
(define frame (new frame% 
     [label "League of Legends Statistics Tracker"]
     [width 300]
     [height 300]))

(send frame show #t)

(define msg (new message% 
     [parent frame]
     [label "Welcome to the LoL Stats Tracker."]))

(define sn-input (new text-field% 
     [parent frame]
     [label "Summoner Name: "]
     [init-value ""]
     [callback (lambda(f ev)
                 (send f get-value))
                 ]))

(define submit-button (new button% 
     [parent frame]
     [label "Search"]
     [callback (lambda (button event)
                 (let ([v (send sn-input get-value)])
                   (query-for-summoner v))
                 (send msg set-label "Searching for user..."))]))

```
