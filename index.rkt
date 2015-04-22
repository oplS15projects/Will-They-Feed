#lang racket

(require 
     web-server/servlet
     web-server/servlet-env
     web-server/templates
     xml
)


(define (start req)
  (response/xexpr
     (let ([summonername "Raker"] [title "Will They Feed?"]) 
       (include-template "index.html")
      )
  )
)

(serve/servlet start)