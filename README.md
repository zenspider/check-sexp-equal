# check-sexp-equal?

A simple extension for rackunit that provides structural diffs on failure.

## Example:

Here's a normal `check-equal?` failure with a reasonably complex sexp:

```
FAILURE
actual:     (a (foo bar foo bar b c d e f (g h i j k l)) (m n o p q (r s t u v w x y z)))
expected:   (a (foo bar foo bar b c d e f (g h i j k l)) (m n o p q (r s t u v 0 x y z)))
name:       check-equal?
location:   (#<path:/Users/ryan/Desktop/racketcola/check-sexp-equal.rkt> 26 4 835 18)
expression: (check-equal? a b)
Check failure
--------------------
--------------------
```

With `check-sexp-equal?` you'd get:

```
FAILURE
name:       check-sexp-equal?
location:   (#<path:.../check-sexp-equal.rkt> 29 4 999 23)
expression: (check-sexp-equal? a b)
params:     ((a (foo bar foo bar b c d e f (g h i j k l)) (m n o p q (r s t u v w x y z))) (a (foo bar foo bar b c d e f (g h i j k l)) (m n o p q (r s t u v 0 x y z))))

sexp-diff (#:new = actual, #:old = expected):

'((a
   (foo bar foo bar b c d e f (g h i j k l))
   (m n o p q (r s t u v #:new w #:old 0 x y z))))
--------------------
```

## License:

(The MIT License)

Copyright (c) Ryan Davis, seattle.rb

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
