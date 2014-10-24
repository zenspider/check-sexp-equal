#lang racket

(require rackunit
         sexp-diff) ;; raco pkg install sexp-diff

(provide check-sexp-equal?)

;; check-equal? doesn't even pretty-print the sexprs, which can be
;; very long and hard to compare. Anyway let's do even better and use
;; sexp-diff to highlight to diff.

(define-check (check-sexp-equal? a b)
  (with-check-info*
      (list (make-check-message "see sexp diff below. #:new = actual"))
    (lambda ()
      (let ((result (equal? a b)))
        (or result
            (fail-check (format "sexp-diff:~n~n~a"
                                (pretty-format (sexp-diff b a)))))))))

(module+ test
  (let ([a '(a (foo bar foo bar b c d e f (g h i j k l))
             (m n o p q (r s t u v w x y z)))]
        [b '(a (foo bar foo bar b c d e f (g h i j k l))
             (m n o p q (r s t u v 0 x y z)))])
    (check-equal? a b)
    (check-sexp-equal? a b)))
