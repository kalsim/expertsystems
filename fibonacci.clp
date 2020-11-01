/*
** Montek Kalsi
** January 30, 2019
**
** Collection of JESS functions used to evaluate fibonacci sequences
**
** fibo        - computes fibonacci sequences
** check       - determines whether an input is valid
** fibonacci   - if the input is valid, it outputs the fibonacci sequence of length input
** castLong    - casts a value to a long and returns the long
** fib         - takes in user input; if it's valid, computes the fibonacci sequence
*/


(reset)
(clear)
(batch utilities.clp)


/*
** The function fibo takes in parameter ?x and outputs a list of length
** ?x containing the first ?x elements of the fibonacci sequence. ?x must be
** a number. If the parameter is less than or equal to 1, then a list with 
** the first fibonacci term is returned. If ?x is a positive decimal, the function
** floors it and outputs that number of terms in the sequence.
*/
(deffunction fibo (?x)
   (bind ?lis (create$ 1))
   
   (if (>= ?x 2) then (bind ?lis (insert$ ?lis 1 1)))
   
   (for (bind ?i 3) (<= ?i ?x) (++ ?i)
      (bind ?prev1 (nth$ (- ?i 1) ?lis))
      (bind ?prev2 (nth$ (- ?i 2) ?lis))
      (bind ?lis (insert$ ?lis ?i (+ ?prev1 ?prev2)))
   )
   
   (return ?lis)
)

/*
** This function check returns TRUE if the parameter ?x is a positive
** number.
*/
(deffunction check (?x)
   (return (and (numberp ?x)(< 0 ?x)))
)

/*
** Fibonacci takes in parameter ?x. If ?x is valid by the check function,
** fibo is called on ?x and its output is stored and returned. If ?x
** is invalid, FALSE is returned. 
*/
(deffunction fibonacci (?x)
   (if (not (check ?x)) then (bind ?ans FALSE)
    else (bind ?ans (fibo ?x))
   )
   
   (return ?ans)
)

/*
** The function castLong outputs the parameter ?x as a long, 
** excising the values past the decimal point.
*/
(deffunction castLong (?x)
   (if (longp ?x) then (bind ?out ?x)
    else (bind ?out (long ?x))
   )

   (return ?out)
)

/*
** The function fib takes in reader input. It prompts the user to enter
** a positive number until the user complies. It calls the function fibonacci
** on the user's input and stores the list which is returned. Then, it outputs this
** list which contains the number of terms in the fibonacci sequence that the 
** user specified.
*/
(deffunction fib () 
   (bind ?readerinput (ask "Enter a number: "))
   (bind ?l (fibonacci ?readerinput))
   
   (while (not ?l) do
      (bind ?readerinput (ask "Invalid input; enter a positive number. "))
      (bind ?l (fibonacci ?readerinput))
   )

   (bind ?readerinput (castLong ?readerinput))
   (bind ?out (str-cat "The first " ?readerinput " numbers of the fibonacci sequence are "))
   (printout t ?out crlf)
   
   (return ?l)
)

(fib)

