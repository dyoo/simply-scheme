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
          @item{@racket[appearances]*}
               @item{@racket[before?]*}
               @item{@racket[butfirst], @racket[bf]*}
               @item{@racket[butlast], @racket[bl]*}
               @item{@racket[count]*}
               @item{@racket[empty?]*}
               @item{@racket[equal?]}
               @item{@racket[first]*}
               @item{@racket[item]*}
               @item{@racket[last]*}
               @item{@racket[member?]*}
               @item{@racket[quote]}
               @item{@racket[sentence], @racket[se]*}
               @item{@racket[sentence?]*}
               @item{@racket[word]*}
               @item{@racket[word?]*}
          ]

@subsection{Lists}
@itemlist[
          @item{@racket[append]}
               @item{@racket[assoc]}
               @item{@racket[car]}
               @item{@racket[cdr]}
               @item{@tt{c...r}}
               @item{@racket[cons]}
               @item{@racket[filter]*}
               @item{@racket[for-each]}
               @item{@racket[length]}
               @item{@racket[list]}
               @item{@racket[list?]}
               @item{@racket[list-ref]}
               @item{@racket[map]}
               @item{@racket[member]}
               @item{@racket[null?]}
               @item{@racket[reduce]*}
          ]


@subsection{Trees}
@itemlist[
          @item{@racket[children]*}
               @item{@racket[datum]*}
               @item{@racket[make-node]*}
               ]


@subsection{Arithmetic}
@itemlist[
          @item{@racket[+], @racket[-], @racket[*], @racket[/]}
               @item{@racket[<], @racket[<=], @racket[=], @racket[>], @racket[>=]}
               @item{@racket[abs]}
               @item{@racket[ceiling]}
               @item{@racket[cos]}
               @item{@racket[even?]}
               @item{@racket[expt]}
               @item{@racket[floor]}
               @item{@racket[integer?]}
               @item{@racket[log]}
               @item{@racket[max]}
               @item{@racket[min]}
               @item{@racket[number?]}
               @item{@racket[odd?]}
               @item{@racket[quotient]}
               @item{@racket[random]}
               @item{@racket[remainder]}
               @item{@racket[round]}
               @item{@racket[sin]}
               @item{@racket[sqrt]}
           ]

@subsection{True and False}
@itemlist[
          @item{@racket[and]}
               @item{@racket[boolean]}
               @item{@racket[cond]}
               @item{@racket[if]}
               @item{@racket[not]}
               @item{@racket[or]}
          ]

@subsection{Variables}
@itemlist[
          @item{@racket[define]}
               @item{@racket[let]}
           ]


@subsection{Vectors}
@itemlist[
          @item{@racket[list->vector]}
               @item{@racket[make-vector]}
               @item{@racket[vector]}
               @item{@racket[vector?]}
               @item{@racket[vector-length]}
               @item{@racket[vector->list]}
               @item{@racket[vector-ref]}
               @item{@racket[vector-set!]}
          ]


@subsection{Procedures}

@itemlist[
          @item{@racket[apply]}
               @item{@racket[lambda]}
               @item{@racket[procedure?]}
          ]

@subsection{Higher-Order Procedures}
@itemlist[
          @item{@racket[accumulate]*}
               @item{@racket[every]*}
               @item{@racket[filter]*}
               @item{@racket[for-each]}
               @item{@racket[keep]*}
               @item{@racket[map]}
               @item{@racket[reduce]*}
               @item{@racket[repeated]*}
          ]


@subsection{Control}
@itemlist[
          @item{@racket[begin]}
               @item{@racket[error]}
               @item{@racket[load]}
               @item{@racket[trace]}
               @item{@racket[untrace]}
           ]


@subsection{Input / Output}
@itemlist[
          @item{@racket[align*]}
               @item{@racket[display]}
               @item{@racket[newline]}
               @item{@racket[read]}
               @item{@racket[read-line]*}
               @item{@racket[read-string]*}
               @item{@racket[show]*}
               @item{@racket[show-line]*}
               @item{@racket[write]}
          ]

@subsection{Files and Ports}
@itemlist[
          @item{@racket[close-all-ports]*}
               @item{@racket[close-input-port]}
               @item{@racket[close-output-port]}
               @item{@racket[eof-object?]}
               @item{@racket[open-input-file]}
               @item{@racket[open-output-file]}
          ]



@section{Alphabetical Listing of Scheme Primitives}
    
@defmodule/this-package[main]


@;@defidform[quote]{Quotation; abbreviated with @litchar{'}.}

@defidform[*]{multiply numbers}

@defidform[+]{add numbers}

@defidform[-]{subtract numbers}

@defidform[/]{divide numbers}

@defidform[<]{Is the first argument less than the second?}

@defidform[<=]{Is the first argument less than or equal to the second?}

@defidform[=]{Are two numbers equal?  (Like equal? but works only for numbers)}

@defidform[>]{Is the first argument greater than the second?}

@defidform[>=]{Is the first argument greater than or equal to the second?}

@defidform[abs]{Return the absolute value of the argument.}

@defidform[accumulate]{Apply a combining function to all the elements.}

@defidform[align]{Return a string spaced to a given width.}

@defidform[and]{(Special form) Are all of the arugments true values (i.e., not #f)?}

@defidform[appearances]{Return the number of times the first argument is in the second.}

@defidform[append]{Return a list containing the elements of the argument lists.}

@defidform[apply]{Apply a function to the arguments in a list.}

@defidform[assoc]{Return association list entry matching key.}

@defidform[before?]{Does the first argument come alphabetically before the second?}

@defidform[begin]{(Special form) Carry out a sequence of instructions.}

@defidform[bf]{Abbreviation for butfirst.}

@defidform[bl]{Abbreviation for butlast.}

@defidform[boolean?]{Return true if the argument is #t or #f.}

@defidform[butfirst]{Return all but the first letter of a word, or word of a sentence.}

@defidform[butlast]{Return all but the last letter of a word, or word of a sentence.}

@defidform[c...r]{Combinations of car and cdr.}

@defidform[car]{Return the first element of a list.}

@defidform[cdr]{Return all but the first element of a list.}

@defidform[ceiling]{Round a number up to the nearest integer.}

@defidform[children]{Return a list of the children of a tree node.}

@defidform[close-all-ports]{Close all open input and output ports.}

@defidform[close-input-port]{Close an input port.}

@defidform[close-output-port]{Close an output port.}

@defidform[cond]{(Special form) Choose among several alternatives.}

@defidform[cons]{Prepend an element to a list.}

@defidform[cos]{Return the cosine of a number (from trigonometry).}

@defidform[count]{Return the number of letters in a word or number of words in a sentence.}

@defidform[datum]{Return the datum of a tree node.}

@defidform[define]{(Special form) Create a global name (for a procedure or other value).}

@defidform[display]{Print the argument without starting a new line.}

@defidform[empty?]{Is the arugment empty, i.e., the empty word "" or the empty sentence ()?}

@defidform[eof-object?]{Is the argument an end-of-file object?}

@defidform[equal?]{Are the two arguments the same thing?}

@defidform[error]{Print an error message and return to the Scheme prompt.}

@defidform[even?]{Is the argument an even integer?}

@defidform[every]{Apply a function to each element of a word or sentence.}

@defidform[expt]{Raise the first argument to the power of the second.}

@defidform[filter]{Select a subset of a list.}

@defidform[first]{Return first letter of a word, or first word of a sentence.}

@defidform[floor]{Round a number down to the nearest integer.}

@defidform[for-each]{Perform a computation for each element of a list.}

@defidform[if]{(Special form) Choose between two alternatives.}

@defidform[integer?]{Is the argument an integer?}

@defidform[item]{Return the nth letter of a word, or nth word of a sentence.}

@defidform[keep]{Select a subset of a word or sentence.}

@defidform[lambda]{(special form) Create a new procedure.}

@defidform[last]{Return last letter of a word, or last word of a sentence.}

@defidform[length]{Return the number of elements in a list.}

@defidform[let]{(Special form) Give temporary names to values.}

@defidform[list]{Return a list containing the arguments.}

@defidform[list->vector]{Return a vector with the same elements as the list.}

@defidform[list-ref]{Select an element from a list (counting from zero).}

@defidform[list?]{Is the argument a list?}

@defidform[load]{Read a program file into Scheme.}

@defidform[log]{Return the logarithm of a number.}

@defidform[make-node]{Create a new node of a tree.}

@defidform[make-vector]{Create a new vector of the given length.}

@defidform[map]{Apply a function to each element of a list.}

@defidform[max]{Return the largest of the arguments.}

@defidform[member]{Return subset of a list starting with the selected element, or #f.}

@defidform[member?]{Is the first argument an element of the second?}

@defidform[min]{Return the smallest of the arguments.}

@defidform[newline]{Go to a new line of printing.}

@defidform[not]{Return #t if the argument is #f; return #f otherwise.}

@defidform[null?]{Is the argument the empty list?}

@defidform[number?]{Is the argument a number?}

@defidform[odd?]{Is the argument an odd number?}

@defidform[open-input-file]{Open a file for reading, return a port.}

@defidform[open-output-file]{Open a file for writing, return a port.}

@defidform[or]{(Special form) Are any of the arguments true values (i.e., not #f)?}

@defidform[procedure?]{Is the argument a procedure?}

@defidform[quote]{(Special form) Return the argument, unevaluated.}

@defidform[quotient]{Divide number, but round down to integer}

@defidform[random]{Return a random number >= 0 and smaller than the argument}

@defidform[read]{Read an expression from the keyboard (or a file).}

@defidform[read-line]{Read a line from the keyboard (or a file), returning a sentence.}

@defidform[read-string]{Read a line from the keyboard (or a file), returning a string.}

@defidform[reduce]{Apply a combining function to all elements of list.}

@defidform[remainder]{Return the remainder from dividing the first number by the second.}

@defidform[repeated]{Return the function described by f(f(...(f(x)))).}

@defidform[round]{Round a number to the nearest integer.}

@defidform[se]{Abbreviation for sentence.}

@defidform[sentence]{Join the arguments together into a big sentence.}

@defidform[sentence?]{Is the argument a sentence?}

@defidform[show]{Print the argument and start a new line.}

@defidform[show-line]{Show the argument sentence without surrounding parentheses.}

@defidform[sin]{Return the sine of a number (from trigonometry).}

@defidform[sqrt]{Return the square root of a number.}

@defidform[square]{Not a primitive!  (define (square x) (* x x)).}

@defidform[trace]{Report on all further invocations of a procedure.}

@defidform[untrace]{Undo the effects of trace.}

@defidform[vector]{Create a vector with the arguments as elements.}

@defidform[vector->list]{Return a list with the same elements as the vector.}

@defidform[vector-length]{Return the number of elements in a vector.}

@defidform[vector-ref]{Return an element of a vector (counting from zero).}

@defidform[vector-set!]{Replace an element in a vector.}

@defidform[vector?]{Is the argument a vector?}

@defidform[vowel?]{Not a primitive!  (define (vowel? x) (member x '(a e i o u)))}

@defidform[word]{Joins words into one big word.}

@defidform[word?]{Is the argument a word? (Note: numbers are words.)}

@defidform[write]{Print the argument in machine-readable form.}




@section{Deviations from plain @racketmodname[racket]}
@subsection{Strings are numbers}

One distinguishing feature of this language is the abstraction of
numbers.  Strings are also treated as numbers by the arithmetic
operators:
@interaction[#:eval my-evaluator
                    (+ "40" 2)]


This can be enabled or disabled by using @racket[strings-are-numbers]:

@declare-exporting/this-package[main]
@defidform[strings-are-numbers]{
If bool is set to #t, strings will be treated as numbers, and the
arithmetic operators will be overloaded to work with strings.  If bool
is set to #f, strings will not be treated as numbers.}





@section{Differences from the book and things to fix}

FIXME: the other helper libraries haven't been mapped yet. (things like
functions.scm would be nice to have as a library.)

I also need to improve the documentation to use Scribble features; the
current work is a rush job.



@section{Thanks!}

Thanks to my professors at UC Berkeley, especially Brian Harvey and
Dan Garcia.  Yes, CS61A was the best computer science class I've taken.

Thanks to Reid Oda for catching a very ugly bug involving namespaces,
and Matthew Flatt for telling me how to fix it.  See 
@url{http://list.cs.brown.edu/pipermail/plt-scheme/2007-February/016387.html}.
