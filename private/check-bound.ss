(module check-bound mzscheme
  ;; Checks to see if a name is already bound.
  ;; Danny Yoo (dyoo@hkn.eecs.berkeley.edu)

  (provide bound? bound-in-namespace? bound-in-mzscheme-namespace?)

  ;; Returns true if the name is bound in some namespace
  (define (bound-in-namespace? name ns)
    ;; FIXME: read about contracts to force name to be a symbol
    (parameterize ((current-namespace ns))
		  (if (memq name (namespace-mapped-symbols))
		      #t
		      #f)))


  ;; Returns true if the name is bound in the current namespace.
  (define (bound? name)
    (bound-in-namespace? name (current-namespace)))


  ;; Returns true if the name is bound in the primitive mzscheme
  ;; namespace.
  (define (bound-in-mzscheme-namespace? name)
    (bound-in-namespace? name (make-namespace)))
)
