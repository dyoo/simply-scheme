(module info (lib "infotab.ss" "setup")
  (define name "Simply Scheme")
  (define blurb '("Definitions to support programs written for Simply Scheme."))
  (define doc.txt "doc.txt")
  (define help-desk-message "Mz/Mr: (require (lib \"simply-scheme.ss\" \"simply-scheme\"))")


  
  (define compile-omit-files (list "private/check-bound.ss" 
				   "private/simply.scm" 
				   "private/convert-simply.scm"
				   "make-distribution.ss"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Language stuff

;; let's have a nice little icon in there.
;  (define tool-icons
;    (list '("simply-scheme.gif" "simply-scheme")))

  (define drscheme-language-modules
    (list '("simply-scheme.ss" "simply-scheme")))
  ;; We'll place this right beneath the other teaching languages
  (define drscheme-language-positions
    (list '("Teaching Languages" "Simply Scheme")))

  ;; Note: The other teaching langauges have a category number of -500, so we have
  ;; to match that.
  (define drscheme-language-numbers
    (list '(-500 0)))
  

  )