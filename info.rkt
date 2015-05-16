#lang info

(define version "1.0.0")

(define collection "check-sexp-equal")

(define deps '(("sexp-diff" #:version "0.1")
               "base"
               "rackunit-lib"))

(define build-deps '("racket-doc"
                     "scribble-lib" "unstable-list-lib"))

(define scribblings '(("check-sexp-equal.scrbl" ())))
