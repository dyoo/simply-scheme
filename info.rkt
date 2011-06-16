#lang setup/infotab
(define name "Simply Scheme")
(define blurb '("Definitions to support programs written for Simply Scheme."))
(define release-notes '((p "Ported to Racket 5.1.1")))
(define version "2.0")
(define categories '(misc))
(define primary-file "main.rkt")
(define required-core-version "5.1.1")
(define repositories (list "4.x"))

;; Ignore these paths: they're here just for historical curiosity.
(define compile-omit-paths (list "private" "make-distribution.rkt"))


(define drracket-name  "Simply Scheme")
(define drracket-tools (list (list "tool.rkt")))