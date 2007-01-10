(module info (lib "infotab.ss" "setup")
  (define name "Simply Scheme")
  (define blurb '("Definitions to support programs written for Simply Scheme."))
  (define doc.txt "doc.txt")
  (define categories '(misc))
  (define primary-file "simply-scheme.ss")
  
  (define compile-omit-files (list "private/check-bound.ss" 
				   "private/simply.scm" 
				   "private/convert-simply.scm"
				   "make-distribution.ss"))
  
  (define tools (list (list "tool.ss")))
  (define tool-names (list "Simply Scheme")))