#lang racket
(require web-server/servlet
         web-server/servlet-env)
 
(define word "Joke 1" )
(define word1 "Joke 2")
(define word2 "Joke 3")
(define word3 "Joke 4")
(define word4 "Joke 5")
(define word5 "Joke 6")

(define Joke1 "What happens to a frog's car when it breaks down?
                 It gets toad away.")
(define Joke2 "Q: What did the duck say when he bought lipstick?
                  A: Put it on my bill.")
(define Joke3 "Q: Why was six scared of seven? 
                 A: Because seven ate nine.") 
(define Joke4  "My friend thinks he is smart. He told me an onion is the only food that makes you cry, so I threw a coconut at his face.")
(define Joke5  "In a Catholic school cafeteria, a nun places a note in front of a pile of apples, (Only take one. God is watching.) Further down the line is a pile of cookies. A little boy makes his own note, (Take all you want. God is watching the apples.)")
(define Joke6 "Mr. and Mrs. Brown had two sons. One was named Mind Your Own Business & the other was named Trouble. One day the two boys decided to play hide and seek. Trouble hid while Mind Your Own Business counted to one hundred. Mind Your Own Business began looking for his brother behind garbage cans and bushes. Then he started looking in and under cars until a police man approached him and asked, (What are you doing?) (Playing a game,) the boy replied. (What is your name?) the officer questioned. (Mind Your Own Business.) Furious the policeman inquired, (Are you looking for trouble?!) The boy replied, (Why, yes.)")

(define (start req)
  (response/xexpr
   `(html (head (title "Jokes"))
          (body (h1, word)
              (p, Joke1 )
              (h1, word1)
              (p, Joke2 )
              (h1, word2)
              (p, Joke3 )
              (h1, word3)
              (p, Joke4)
              (h1, word4)
              (p, Joke5)
              (h1, word5)
              (p, Joke6 )))))
            
                
                
                
  

 
(serve/servlet start)