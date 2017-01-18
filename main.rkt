#lang racket

(require rackunit
         sexp-diff) ;; raco pkg install sexp-diff

(provide check-sexp-equal? old/check-sexp-equal? check-exn-info?)

;; check-equal? doesn't even pretty-print the sexprs, which can be
;; very long and hard to compare. Anyway let's do even better and use
;; sexp-diff to highlight to diff.

(define-check (old/check-sexp-equal? a b)
  (or (equal? a b)
      (fail-check (format "sexp-diff (#:new = actual, #:old = expected):~n~n~a"
                          (pretty-format (first (sexp-diff b a)))))))

(define-check (check-sexp-equal? a b)
  (or (equal? a b)
      (with-check-info (['actual a]
                        ['expected b]
                        ['sexp-diff (first (sexp-diff b a))]
                        ['key "sexp-diff (#:new = actual, #:old = expected)"])
        (fail-check))))

(define (check-stack->hash lst)
  (for/hash ([info (in-list lst)])
    (values (check-info-name info)
            (check-info-value info))))

(define-check (check-exn-info? proc message info)
  (define failure (with-handlers ([exn:test:check? identity])
                    (parameterize ([current-check-around (λ (proc) (proc))])
                      (proc))
                    #f))
  (unless failure (fail-check "No failure raised"))
  (define info-hash (check-stack->hash (exn:test:check-stack failure)))
  (check-equal? (exn-message failure) message "failed to match exn message")
  (for ([(k v) (in-hash info)])
    (check-equal? (hash-ref info-hash k (not v)) v)))

(module+ test
  (let ([a '(a (foo bar foo bar b c d e f (g h i j k l))
               (m n o p q (r s t u v w x y z)))]
        [b '(a (foo bar foo bar b c d e f (g h i j k l))
               (m n o p q (r s t u v 0 x y z)))]
        [c '(a
             (foo bar foo bar b c d e f (g h i j k l))
             (m n o p q (r s t u v #:new w #:old 0 x y z)))])

    (check-exn-info? (thunk (check-equal? a b))          ; not terribly useful
                     "Check failure"
                     (hash 'actual a
                           'expected b))

    (check-exn-info? (thunk (old/check-sexp-equal? a b)) ; much better
                     #<<DONE
sexp-diff (#:new = actual, #:old = expected):

'(a
  (foo bar foo bar b c d e f (g h i j k l))
  (m n o p q (r s t u v #:new w #:old 0 x y z)))
DONE
                     (hash))

    (check-exn-info? (thunk (check-sexp-equal? a b))     ; best?
                     "Check failure"
                     (hash 'actual a
                           'expected b
                           'sexp-diff c))
    ))
