#lang racket/gui

;; Some tool support for Simply Scheme.  I want that nice icon!

(require drracket/tool
         string-constants)
         
(provide tool@)


(define tool@
  (unit
    (import drracket:tool^)
    (export drracket:tool-exports^)
    
    (define language-base%
      (class* drracket:language:simple-module-based-language%
        (drracket:language:simple-module-based-language<%>)
        
        (define (get-language-numbers)
          '(-500 0))
        
        (define (get-language-position)
          (list (string-constant teaching-languages)
                "Simply Scheme"))
        
        (define (get-module)
          '(planet dyoo/simply-scheme:2/simply-scheme))
 
        (define (get-one-line-summary)
          "Based on the Simply Scheme textbook")
        
        (super-new [module (get-module)]
                   [language-position (get-language-position)]
                   [language-numbers (get-language-numbers)]
                   [one-line-summary (get-one-line-summary)]
                   [documentation-reference #f])))
    
    (define language%
      (class (drracket:language:module-based-language->language-mixin
              (drracket:language:simple-module-based-language->module-based-language-mixin
               language-base%))
        ;; We need to flag use-namespace-require/copy to prevent
        ;; a weird bug.  See:
        ;; http://list.cs.brown.edu/pipermail/plt-scheme/2007-February/016390.html
        (define/override (use-namespace-require/copy?) #t)
        (super-instantiate ())))
    
    
    (define (phase1) (void))
    
    (define (phase2)
      (drracket:language-configuration:add-language
       (make-object ((drracket:language:get-default-mixin) language%))))))