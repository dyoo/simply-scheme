#lang scribble/manual

@(require planet/scribble
          planet/version
          planet/resolver
          scribble/eval
          racket/sandbox
          (for-label (this-package-in main)))

@(define my-evaluator
   (call-with-trusted-sandbox-configuration 
    (lambda ()
      (parameterize ([sandbox-output 'string]
                     [sandbox-error-output 'string])
        (make-evaluator 
         'racket/base
         #:requires
         (list (resolve-planet-path `(planet , (this-package-version-symbol main)))))))))


@title{Simply Scheme Support Definitions}
@author+email["Danny Yoo" "dyoo@cs.wpi.edu"]

@section{Introduction}

This library adds a @link["http://www.eecs.berkeley.edu/~bh/ss-toc2.html"]{Simply Scheme}
teaching language into DrRacket; the language is used in the textbook:

@verbatim{
    Simply Scheme / Introducing Computer Science, Second Edition
    Brian Harvey and Matthew Wright
    MIT Press, 1999
    http://www.cs.berkeley.edu/~bh/ss-toc2.html
}
    
The original source of these programs can be found from the FTP site at    @url{ftp://ftp.cs.berkeley.edu/pub/scheme}.  The definitions in this library 
should correspond to those in
@filepath{simply.scm} version 3.13 (8/11.98).


@section{Quick Start}

Although we use these definitions from switching the DrRacket language level to Simply Scheme,
this library can also be easily used as a @litchar{#lang} language.

For example, if your DrRacket language level has been set to
@emph{Determine langauge from source}, then the following example should run without
any trouble:

@codeblock|{
#lang planet dyoo/simply-scheme:2
(se (butlast (bf "this"))
    "world")
}|   
           




@section{Table of Scheme Primitives by Category}

(Primitives with a '*' are not part of standard Scheme)

@subsection{Words and Sentences}
@itemlist[
          appearances*
          before?*
          butfirst (bf)*
          butlast (bl)*
          count*
          empty?*
          equal?
          first*
          item*
          last*
          member?*
          quote
          sentence (se)*
          sentence?*
          word*
          word?*
          ]

@subsection{Lists}
@itemlist[
          append
          assoc
          car
          cdr
          c...r
          cons
          filter*
          for-each
          length
          list
          list?
          list-ref
          map
          member
          null?
          reduce*
          ]


@subsection{Trees}
@itemlist[
          children*
          datum*
          make-node*
          ]


@subsection{Arithmetic}
@itemlist[
          +, -, *, /
           <, <=, =, >, >=
           abs
           ceiling
           cos
           even?
           expt
           floor
           integer?
           log
           max
           min
           number?
           odd?
           quotient
           random
           remainder
           round
           sin
           sqrt
           ]

@subsection{True and False}
@itemlist[
          and
          boolean
          cond
          if
          not
          or
          ]

@subsection{Variables}
@itemlist[
          define
           let
           ]


@subsection{Vectors}
@itemlist[
          list->vector
          make-vector
          vector
          vector?
          vector-length
          vector->list
          vector-ref
          vector-set!
          ]


@subsection{Procedures}

@itemlist[
          apply
          lambda
          procedure?
          ]

@subsection{Higher-Order Procedures}
@itemlist[
          accumulate*
          every*
          filter*
          for-each
          keep*
          map
          reduce*
          repeated*
          ]


@subsection{Control}
@itemlist[
          begin
           error
           load
           trace
           untrace
           ]


@subsection{Input / Output}
@itemlist[
          align*
          display
          newline
          read
          read-line*
          read-string*
          show*
          show-line*
          write
          ]

@subsection{Files and Ports}
@itemlist[
          close-all-ports*
          close-input-port
          close-output-port
          eof-object?
          open-input-file
          open-output-file
          ]



@section{Primitives}
    
Alphabetical Table of Scheme Primitives

> '
Abbreviation for (quote ...)

> *
multiply numbers

> +
add numbers

> -
subtract numbers

> /
divide numbers

> <
Is the first argument less than the second?

> <=
Is the first argument less than or equal to the second?

> =
Are two numbers equal?  (Like equal? but works only for numbers)

> >
Is the first argument greater than the second?

> >=
Is the first argument greater than or equal to the second?


> abs
Return the absolute value of the argument.

> accumulate
Apply a combining function to all the elements.

> align
Return a string spaced to a given width.

> and
(Special form) Are all of the arugments true values (i.e., not #f)?

> appearances
Return the number of times the first argument is in the second.

> append
Return a list containing the elements of the argument lists.

> apply
Apply a function to the arguments in a list.

> assoc
Return association list entry matching key.

> before?
Does the first argument come alphabetically before the second?

> begin
(Special form) Carry out a sequence of instructions.

> bf
Abbreviation for butfirst.

> bl
Abbreviation for butlast.

> boolean?
Return true if the argument is #t or #f.

> butfirst
Return all but the first letter of a word, or word of a sentence.

> butlast
Return all but the last letter of a word, or word of a sentence.

> c...r
Combinations of car and cdr.

> car
Return the first element of a list.

> cdr
Return all but the first element of a list.

> ceiling
Round a number up to the nearest integer.

> children
Return a list of the children of a tree node.

> close-all-ports
Close all open input and output ports.

> close-input-port
Close an input port.

> close-output-port
Close an output port.

> cond
(Special form) Choose among several alternatives.

> cons
Prepend an element to a list.

> cos
Return the cosine of a number (from trigonometry).

> count
Return the number of letters in a word or number of words in a sentence.

> datum
Return the datum of a tree node.

> define
(Special form) Create a global name (for a procedure or other value).

> display
Print the argument without starting a new line.

> empty?
Is the arugment empty, i.e., the empty word "" or the empty sentence ()?

> eof-object?
Is the argument an end-of-file object?

> equal?
Are the two arguments the same thing?

> error
Print an error message and return to the Scheme prompt.

> even?
Is the argument an even integer?

> every
Apply a function to each element of a word or sentence.

> expt
Raise the first argument to the power of the second.

> filter
Select a subset of a list.

> first
Return first letter of a word, or first word of a sentence.

> floor
Round a number down to the nearest integer.

> for-each
Perform a computation for each element of a list.

> if
(Special form) Choose between two alternatives.

> integer?
Is the argument an integer?

> item
Return the nth letter of a word, or nth word of a sentence.

> lambda
(special form) Create a new procedure.

> last
Return last letter of a word, or last word of a sentence.

> length
Return the number of elements in a list.

> let
(Special form) Give temporary names to values.

> list
Return a list containing the arguments.

> list->vector
Return a vector with the same elements as the list.

> list-ref
Select an element from a list (counting from zero).

> list?
Is the argument a list?

> load
Read a program file into Scheme.

> log
Return the logarithm of a number.

> make-node
Create a new node of a tree.

> make-vector
Create a new vector of the given length.

> map
Apply a function to each element of a list.

> max
Return the largest of the arguments.

> member
Return subset of a list starting with the selected element, or #f.

> member?
Is the first argument an element of the second?

> min
Return the smallest of the arguments.

> newline
Go to a new line of printing.

> not
Return #t if the argument is #f; return #f otherwise.

> null?
Is the argument the empty list?

> number?
Is the argument a number?

> odd?
Is the argument an odd number?

> open-input-file
Open a file for reading, return a port.

> open-output-file
Open a file for writing, return a port.

> or
(Special form) Are any of the arguments true values (i.e., not #f)?

> procedure?
Is the argument a procedure?

> quote
(Special form) Return the argument, unevaluated.

> quotient
Divide number, but round down to integer

> random
Return a random number >= 0 and smaller than the argument

> read
Read an expression from the keyboard (or a file).

> read-line
Read a line from the keyboard (or a file), returning a sentence.

> read-string
Read a line from the keyboard (or a file), returning a string.

> reduce
Apply a combining function to all elements of list.

> remainder
Return the remainder from dividing the first number by the second.

> repeated
Return the function described by f(f(...(f(x)))).

> round
Round a number to the nearest integer.

> se
Abbreviation for sentence.

> sentence
Join the arguments together into a big sentence.

> sentence?
Is the argument a sentence?

> show
Print the argument and start a new line.

> show-line
Show the argument sentence without surrounding parentheses.

> sin
Return the sine of a number (from trigonometry).

> sqrt
Return the square root of a number.

> square
Not a primitive!  (define (square x) (* x x)).

> trace
Report on all further invocations of a procedure.

> untrace
Undo the effects of trace.

> vector
Create a vector with the arguments as elements.

> vector->list
Return a list with the same elements as the vector.

> vector-length
Return the number of elements in a vector.

> vector-ref
Return an element of a vector (counting from zero).

> vector-set!
Replace an element in a vector.

> vector?
Is the argument a vector?

> vowel?
Not a primitive!  (define (vowel? x) (member x '(a e i o u)))

> word
Joins words into one big word.

> word?
Is the argument a word? (Note: numbers are words.)

> write
Print the argument in machine-readable form.




@section{Deviations from plain @rackmodname[racket]}
@subsection{Strings are numbers}

One distinguishing feature of this language is the abstraction of
numbers.  Strings are also treated as numbers by the arithmetic
operators:
@interaction[#:eval my-evaluator
                    (+ "40" 2)]


This can be enabled or disabled by using _strings-are-numbers_:

> (strings-are-numbers bool)
If bool is set to #t, strings will be treated as numbers, and the
arithmetic operators will be overloaded to work with strings.  If bool
is set to #f, strings will not be treated as numbers.





@section{Differences from the book and things to fix}

FIXME: the other helper libraries haven't been mapped yet. (things like
functions.scm would be nice to have as a library.)




@section{Thanks!}

Thanks to my professors at UC Berkeley, especially Brian Harvey and
Dan Garcia.  Yes, CS61A was the best computer science class I've taken.

Thanks to Reid Oda for catching a very ugly bug involving namespaces,
and Matthew Flatt for telling me how to fix it.  See 
@url{http://list.cs.brown.edu/pipermail/plt-scheme/2007-February/016387.html}.
