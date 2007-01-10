;; Some tool support for Simply Scheme.  I want that nice icon!
;; Almost everything here is a cut-and-paste of the EOPL definitions

(module tool mzscheme
  (require (lib "class.ss")
           (lib "tool.ss" "drscheme")
           (lib "string-constant.ss" "string-constants")
           (planet "version-case.ss" ("dyoo" "version-case.plt" 1 0)))
  
  (version-case
   [(version<= (version) "360.0")
    (require (lib "unitsig.ss"))
    (define-syntax (define-unit-tool stx)
      (syntax-case stx ()
        [(_ name tool-export import-body rest-body ...)
         (syntax/loc stx
           (define name
             (unit/sig tool-export
               import-body
               rest-body ...)))]))]
   [else
    (require (lib "unit.ss"))
    (define-syntax (define-unit-tool stx)
      (syntax-case stx ()
        [(_ name tool-export import-body rest-body ...)
         (syntax/loc stx
           (define-unit name
             import-body
             (export tool-export)
             rest-body ...))]))])
  
  (provide tool@)
  
  
  (define-unit-tool tool@ drscheme:tool-exports^
    (import drscheme:tool^)
    
    (define language-base%
      (class* drscheme:language:simple-module-based-language%
        (drscheme:language:simple-module-based-language<%>)
        
        (define (get-language-numbers)
          '(-500 0))
        (define (get-language-position)
          (list (string-constant teaching-languages)
                "Simply Scheme"))
        (define (get-module)
          '(planet "simply-scheme.ss" ("dyoo" "simply-scheme.plt")))
        (define (get-one-line-summary)
          "Based on the Simply Scheme textbook")
        
        (super-new [module (get-module)]
                   [language-position (get-language-position)]
                   [language-numbers (get-language-numbers)]
                   [one-line-summary (get-one-line-summary)]
                   [documentation-reference #f])))
    
    (define language%
      (class (drscheme:language:module-based-language->language-mixin
              (drscheme:language:simple-module-based-language->module-based-language-mixin
               language-base%))
        (super-instantiate ())))
    
    
    (define (phase1) (void))
    (define (phase2)
      (drscheme:language-configuration:add-language
       (make-object ((drscheme:language:get-default-mixin) language%))))))