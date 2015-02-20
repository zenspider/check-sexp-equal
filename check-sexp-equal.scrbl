#lang scribble/manual

@(require (for-label racket "main.rkt"))
@(require scribble/base scribble/manual scribble/eval
          (for-label racket/base racket/dict syntax/id-table racket/contract
                     unstable/list))

@defmodule[check-sexp-equal]

@title{check-sexp-equal}

@racket[check-equal?] doesn't even @racket[pretty-print] the sexprs on
failure, which can be very long and hard to compare. Anyway let's do
even better and use @racket[sexp-diff] to highlight to diff.

@defproc[(check-sexp-equal? [a any/c] [b any/c])
         (void)]{

Like @racket[check-equal?] but on failure reports using
@racket[sexp-diff] so you can more easily see structural differences
at any level.

The original check-equal with a complex structure, on failure:

@racketblock[
(let ([a '(a (foo bar foo bar b c d e f (g h i j k l))
             (m n o p q (r s t u v w x y z)))]
        [b '(a (foo bar foo bar b c d e f (g h i j k l))
             (m n o p q (r s t u v 0 x y z)))])
    (check-equal? a b))
]

outputs:

@verbatim{
FAILURE
actual:     (a (foo bar foo bar b c d e f (g h i j k l)) (m n o p q (r s t u v w x y z)))
expected:   (a (foo bar foo bar b c d e f (g h i j k l)) (m n o p q (r s t u v 0 x y z)))
name:       check-equal?
location:   (#<path:/Users/ryan/Work/git/zenspider/check-sexp-equal/main.rkt> 22 4 713 18)
expression: (check-equal? a b)

Check failure
}

But switching from @racket[check-equal?] to @racket[check-sexp-equal?] outputs:

@verbatim{
FAILURE
name:       check-sexp-equal?
location:   (#<path:/Users/ryan/Work/git/zenspider/check-sexp-equal/main.rkt> 28 4 926 23)
expression: (check-sexp-equal? a b)
params:     ((a (foo bar foo bar b c d e f (g h i j k l)) (m n o p q (r s t u v w x y z))) (a (foo bar foo bar b c d e f (g h i j k l)) (m n o p q (r s t u v 0 x y z))))

sexp-diff (#:new = actual, #:old = expected):

'((a
   (foo bar foo bar b c d e f (g h i j k l))
   (m n o p q (r s t u v #:new w #:old 0 x y z))))
}

}
