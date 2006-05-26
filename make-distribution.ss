;; Small program to build a PLT file
(require (lib "file.ss"))
(require (lib "pack.ss" "setup"))

(define (copy f d)
  (let ((dest-path (build-path d f)))
    (if (file-exists? dest-path)
	(void)
	(copy-file f (build-path d f)))))

(define collect-path "collects/simply-scheme")
(make-directory* collect-path)
(copy "doc.txt" collect-path)
(copy "info.ss" collect-path)
(copy "simply-scheme.ss" collect-path)
