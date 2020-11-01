/*
** Montek Kalsi
** January 24, 2019
**
** Collection of JESS functions used to evaluate factorials
**
** fact        - computes factorials
** factorial   - takes in user input to return its factorial
** cast        - casts a value to a long and returns the long.
** check       - determines whether an input is valid
*/

(reset)
(clear)
(batch utilities.clp)

/*
** The fact function evaluates the factorial of long ?x with recursion.
** If ?x is negative, the function outputs 1; otherwise, it outputs the
** mathematical factorial of ?x.
*/
(deffunction fact (?x)
   (if (> ?x 0L) then (bind ?out (* ?x (fact (- ?x 1))))
    else (bind ?out 1L)
   ) 

   (return ?out)
)

/*
** The factorial function prompts for user input. If the input is valid
** by the check function, the fact function is called on the input, which is
** cast to a long using the cast function. If it isn't valid, the user is 
** prompted until they enter a valid input. Then, the value output by fact 
** is printed, concatenated with other strings for readability purposes.
*/
(deffunction factorial ()
   (bind ?readerinput (ask "Enter a number: "))

   (while (not (check ?readerinput)) do
      (bind ?readerinput (ask "Invalid input; enter a positive number. "))
   )

   (bind ?readerinput (cast ?readerinput))
   (bind ?out (str-cat ?readerinput "! = " (fact ?readerinput)))

   (printout t ?out crlf)
   (return)
)

/*
** The function cast outputs the parameter ?x as a long, excising the values
** past the decimal point.
*/
(deffunction cast (?x)
   (if (longp ?x) then (bind ?out ?x)
    else (bind ?out (long ?x))
   )

   (return ?out)
)

/*
** This function check returns TRUE if the parameter ?x is a positive
** number.
*/
(deffunction check (?x)
   (return (and (numberp ?x)(<= 0 ?x)))
)

(factorial)
