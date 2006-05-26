;;#!/usr/local/plt/bin/mzscheme -qr
;; Another try at converting simply.scm.
;;
;; Danny Yoo (dyoo@hkn.eecs.berkeley.edu)
;;
;; This program takes "simply.scm" and does a transformation of it so
;; that all the visible symbols are provided.

;; This is slightly tricky because simply.scm tries to set! or
;; redefine existing symbols in mzscheme, and that's prohibited by
;; modules.  We do work to rewrite conflicting symbols.

(require (lib "pretty.ss")
	 (lib "plt-match.ss") 
	 (rename (lib "list.ss") filter filter)
	 (rename (lib "list.ss") sort mergesort)
	 "check-bound.ss"
	 )


;; We read all the expressions we can, then emit a transformed version
;; of the code that's been mzscheme-modularized.
(define (main)
  (let ((expressions (read-primitive-expressions)))
    (let* ((exportable-vars (sort-symbols (get-exportable-vars expressions)))
	   (rewritable-vars (filter bound-in-mzscheme-namespace? 
				    exportable-vars))
           (rewritten-expressions (rewrite-general-top-level-exprs 
                                   expressions 
                                   exportable-vars 
                                   rewritable-vars)))


      (write-prologue rewritable-vars)
      (for-each (lambda (expr) (pretty-print expr) (newline)) rewritten-expressions)
      (write-epilogue exportable-vars rewritable-vars)
      )))




;; Sorts the symbols into something nice looking
(define (sort-symbols symbols)
  (map string->symbol
       (sort 
	(map symbol->string symbols)
	string-ci<?)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (write-prologue rewritable-vars)
  (display "(module simply-scheme mzscheme")
  (newline)
  (for-each (lambda (var)
	      (write (list 'define 
			   (munge-variable-name var)
			   var))
	      (newline))
	    rewritable-vars))

(define ss-prefix "simply-scheme:")


;; writes out the epilogue
(define (write-epilogue exportable-vars rewritable-vars)
  (pretty-print `(provide (all-from-except mzscheme ,@rewritable-vars)))
  (newline)
  (display "(provide ")
  (for-each (lambda (var)
              (if (memq var rewritable-vars)
                  (write `(rename ,(munge-variable-name var) ,var))
                  (write var))
              (newline))
            exportable-vars)
  (display ")") ;; close the provide
  (display ")") ;; close the module
  (newline))



;; Given a variable name, munge it so it has our namespace prefix
(define (munge-variable-name var)
  (string->symbol (string-append ss-prefix 
                                 (symbol->string var))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (rewrite-general-top-level-exprs exprs exportable-vars rewritable-vars)

  (define (rewrite-general-top-level-expr top-level-expr)
    (match top-level-expr
      [(list 'define-values (list defined-variables ...) body)
       (rewrite-define-values defined-variables body)]
      [(list 'define-syntaxes (list defined-variables ...) body)
       (list 'define-syntaxes defined-variables (rewrite-expr body '()))]
      [(list 'require require-spec ...) '()] ;; not handled
      [(list 'require-for-syntax require-spec ...) '()] ;; not handled
      [expr (rewrite-expr expr '())]
      ))
  
  (define (rewrite-define-values defined-variables body)
    ;; fixme: assumes that defined-variables is a list of one one element!
    (let ((remapped-vars (map (lambda (var) (if (memq var rewritable-vars)
                                                (munge-variable-name var)
                                                var))
                              defined-variables)))
      (if (memq (car defined-variables) rewritable-vars)
          (list 'set! (car remapped-vars) (rewrite-expr body'()))
          (list 'define-values remapped-vars (rewrite-expr body '())))))
  
  
  (define (rewrite-expr expr bound-vars)
    (match expr
      [(? symbol? symbol) (rewrite-symbol symbol bound-vars)]
      [(list 'lambda formals exprs ...) 
       (rewrite-lambda formals exprs bound-vars)]
      ;; (case-lambda (formals expr ...) expr) ;; dunno, FIXME?
      [(list 'if expr1 expr2)
       (rewrite-if expr1 expr2 '(#%app (#%top . void)) bound-vars)]
      [(list 'if expr1 expr2 expr3) 
       (rewrite-if expr1 expr2 expr3 bound-vars)]
      [(list 'begin exprs ...) 
       (rewrite-begin* 'begin exprs bound-vars)]
      [(list 'begin0 expr exprs ...)
       (rewrite-begin* 'begin0 (cons expr exprs) bound-vars)]
      [(list 'let-values 
             (list (list (list var-list-list ...) value-expr-list) ...) 
             let-body-exprs ...)
       (rewrite-let-values var-list-list value-expr-list let-body-exprs bound-vars)]
      [(list 'letrec-values 
             (list (list (list var-list-list ...) value-expr-list) ...) 
             let-body-exprs ...) 
       (rewrite-letrec-values var-list-list value-expr-list let-body-exprs bound-vars)]
      [(list 'set! variable expr) 
       (rewrite-set! variable expr bound-vars)]
      [(list 'quote datum) (list 'quote datum)]
      [(list 'quote-syntax datum) (list 'quote-syntax datum)]
      [(list 'with-continuation-mark expr1 expr2 expr3)
       (rewrite-with-continuation-mark expr1 expr2 expr3 bound-vars)]
      [(list '#%app exprs ...) 
       (rewrite-exprs exprs bound-vars)]
      [(list-rest '#%datum datum) datum]
      [(list-rest '#%top id) 
       (rewrite-#%top id bound-vars) ]
;;      [_ expr] ;; fixme
      ))

  (define (rewrite-let-values var-list-list value-expr-list let-body-exprs bound-vars)
    (append (list 'let-values 
                  (rewrite-let-var-values-clauses var-list-list value-expr-list bound-vars))
            (rewrite-exprs let-body-exprs (append (apply append var-list-list)
                                                  bound-vars))))
          
  (define (rewrite-letrec-values var-list-list value-expr-list let-body-exprs bound-vars)
    (append (list 'letrec-values 
                  (rewrite-letrec-var-values-clauses var-list-list value-expr-list bound-vars))
            (rewrite-exprs let-body-exprs (append (apply append var-list-list)
                                                  bound-vars))))

  (define (rewrite-let-var-values-clauses var-list-list value-expr-list bound-vars)
    (if (null? var-list-list)
        '()
        (cons (list (car var-list-list) 
                    (rewrite-expr (car value-expr-list) bound-vars))
              (rewrite-let-var-values-clauses (cdr var-list-list)
                                              (cdr value-expr-list)
                                              bound-vars))))
  

  (define (rewrite-letrec-var-values-clauses var-list-list value-expr-list bound-vars)
    (let ((extended-bound-vars (append (apply append var-list-list)
                                       bound-vars)))
      (let loop ((var-list-list var-list-list)
                 (value-expr-list value-expr-list))
        (if (null? var-list-list)
            '()
            (cons (list (car var-list-list) 
                        (rewrite-expr (car value-expr-list) extended-bound-vars))
                  (loop (cdr var-list-list)
                        (cdr value-expr-list)))))))

  

  
  
  (define (rewrite-exprs exprs bound-vars)
    (map (lambda (e) (rewrite-expr e bound-vars)) exprs))


  (define (rewrite-begin* begin-label exprs bound-vars)
    (cons begin-label (rewrite-exprs exprs bound-vars)))

  (define (rewrite-with-continuation-mark e1 e2 e3 bound-vars)
    (cons 'rewrite-with-continuation-mark
          (rewrite-exprs (list e1 e2 e3) bound-vars)))
  
  (define (rewrite-symbol symbol bound-vars)
    (if (and (not (memq symbol bound-vars))
             (memq symbol rewritable-vars))
        (munge-variable-name symbol)
        symbol))


  (define (rewrite-lambda formals exprs bound-vars)
    (append (list 'lambda formals)
            (rewrite-exprs exprs 
                           (append (extract-formals formals) bound-vars))))

  
  (define (rewrite-if branch-expr true-expr false-expr bound-vars)
    (list 'if 
          (rewrite-expr branch-expr bound-vars)
          (rewrite-expr true-expr bound-vars)
          (rewrite-expr false-expr bound-vars)))
  
  (define (rewrite-#%top id bound-vars)
    (if (and (not (memq id bound-vars))
             (memq id rewritable-vars))
        (munge-variable-name id)
        id))
  
  (define (rewrite-set! var val bound-vars)
    (if (and (not (memq var bound-vars))
             (memq var rewritable-vars))
        (list 'set! (munge-variable-name var)
              (rewrite-expr val bound-vars))
        (list 'set! var val)))
  
  (map (lambda (exp) (rewrite-general-top-level-expr exp)) exprs))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; Returns a list of all the variables that should be exported.
(define (get-exportable-vars expressions)
  (unique (mappend collect-in-general-top-level-expr expressions)))


;; Reads all expressions into a list.  Each expression has been
;; expanded into primitive mzscheme syntax.
(define (read-primitive-expressions)
  (let loop ((next-expr (read)))
    (if (eof-object? next-expr)
	'()
	(cons (syntax-object->datum (expand next-expr))
	      (loop (read))))))


;; Returns a unique list of elements.
(define (unique things)
  (let ((table (make-hash-table)))
    (for-each (lambda (t) (hash-table-put! table t 1)) things)
    (hash-table-map table (lambda (k v) k))))



;; Given a top-level expression, collects the set!'ed and
;; define-values'ed variable names from our s-expressions.
(define (collect-in-general-top-level-expr
	 top-level-expr)
  (match top-level-expr
    [(list 'define-values (list defined-variables ...) body)
     (append defined-variables (collect-in-expr body '()))]
    [(list 'define-syntaxes (list defined-variables ...) body)
     (append defined-variables (collect-in-expr body '()))]
    [(list 'require require-spec ...) '()] ;; not handled
    [(list 'require-for-syntax require-spec ...) '()] ;; not handled
    [expr (collect-in-expr expr '())]
    ))



;; Map-append a function across some elements
(define (mappend function elts)
  (apply append (map function elts)))



;; Returns all the set!-ed variables that haven't been bound earlier.
(define (collect-in-expr expr bound-vars)
  (match expr
    [(? symbol? symbol) '()]
    [(list 'lambda formals exprs ...)
     (collect-in-exprs 
      exprs 
      (append (extract-formals formals) bound-vars))
     ]
    ;; (case-lambda (formals expr ...) ...) ;; dunno, FIXME?
    [(list 'if expr1 expr2) 
     (collect-in-exprs (list expr1 expr2) bound-vars)]
    [(list 'if expr1 expr2 expr3) 
     (collect-in-exprs (list expr1 expr2 expr3) bound-vars)]
    [(list 'begin exprs ...)
     (collect-in-exprs exprs bound-vars)]
    [(list 'begin0 expr exprs ...)
     (collect-in-exprs (cons expr exprs) bound-vars)]
    
    [(list 'let-values 
           (list (list (list vars ...) value-expr) ...) 
           let-body-expr ...)
     (append
      (collect-in-exprs value-expr bound-vars)
      (collect-in-exprs let-body-expr
                        (append (extract-let-vars vars) bound-vars)))]
    [(list 'letrec-values 
           (list (list (list vars ...) value-expr) ...) 
           let-body-expr ...)
     (append
      (collect-in-exprs value-expr 
                        (append (extract-let-vars vars) bound-vars))
      (collect-in-exprs let-body-expr
                        (append (extract-let-vars vars) bound-vars)))]
    [(list 'set! variable expr)
     (append (collect-in-expr expr bound-vars)
             (if (memq variable bound-vars)
                 '()
                 (list variable)))]
    [(list 'quote datum) '()]
    [(list 'quote-syntax datum) '()]
    [(list 'with-continuation-mark expr1 expr2 expr3)
     (collect-in-exprs (list expr1 expr2 expr3) bound-vars)]
    [(list '#%app exprs ...)
     (collect-in-exprs exprs bound-vars)]
    [(list-rest '#%datum datum) '()]
    [(list-rest '#%top datum) '()]
    ))


;; Given the var list list, flattens out the structure to get a list
;; of the symbols.
(define (extract-let-vars var-list-list)
  (apply append var-list-list))


;; Collections all the formal variable names into a list.  All the
;; names have to be symbols.
(define (extract-formals formals)
  (match formals
    [(? symbol? symbol) (list symbol)]
    [(list-rest (? symbol? variables) ... (? symbol? last))
     (append variables (list last))]
    [(list (? symbol? variables) ...) variables]
    ))


;; Helper function to apply collect-in-expr across a list.
(define (collect-in-exprs exprs bound-vars)
  (mappend (lambda (expr) (collect-in-expr expr bound-vars)) exprs))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Start it up.
(with-input-from-file "simply.scm"
  (lambda () (with-output-to-file "simply-scheme.ss"
               (lambda () (main)))))
