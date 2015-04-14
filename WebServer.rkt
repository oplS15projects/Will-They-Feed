#lang racket
(require web-server/servlet
         web-server/servlet-env)
 
(define (start req)
  (response/xexpr
   `(html (head (title "Jokes"))
          (body (h1 "Joke 1")
              (p "What happens to a frog's car when it breaks down?
                 It gets toad away.")
              (h1 "Joke 2")
              (p "Q: What did the duck say when he bought lipstick?
                  A: Put it on my bill.")
              (h1 "Joke 3")
              (p "Q: Why was six scared of seven? 
                 A: Because seven ate nine.")
              (h1 "Joke 4")
              (p "My friend thinks he is smart. He told me an onion is the only food that makes you cry, so I threw a coconut at his face.")
              (h1 "Joke 5")
              (p "In a Catholic school cafeteria, a nun places a note in front of a pile of apples, (Only take one. God is watching.) Further down the line is a pile of cookies. A little boy makes his own note, (Take all you want. God is watching the apples.)")
              (h1 "Joke 6")
              (p "Mr. and Mrs. Brown had two sons. One was named Mind Your Own Business & the other was named Trouble. One day the two boys decided to play hide and seek. Trouble hid while Mind Your Own Business counted to one hundred. Mind Your Own Business began looking for his brother behind garbage cans and bushes. Then he started looking in and under cars until a police man approached him and asked, (What are you doing?) (Playing a game,) the boy replied. (What is your name?) the officer questioned. (Mind Your Own Business.) Furious the policeman inquired, (Are you looking for trouble?!) The boy replied, (Why, yes.)")))))
            
                
                
                
                
                ;  (img ([src,"cat1.jpg"])'(alt "Cat1")'(height "550")'(width "379"))))))
                
                
                
                ;(a ([href, ""]) "Hey out there!")))))
 
(serve/servlet start)