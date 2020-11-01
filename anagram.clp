/*
** Montek Kalsi
** February 26, 2019
**
** Collection of Jess functions which takes in a user's input string of length
** under 10 and outputs every possible anagram of the string. 
*/

(clear)
(reset)
(batch utilities_v2.clp)

(defglobal ?*max_length* = 10)            ;upper bound of the string length to prevent crashing


(deftemplate Letter (slot c) (slot p))    ;template for a letter that combines a character c with position p

/*
** assertLetter takes in two parameters, a letter and position,
** and asserts a fact with the Letter template using both the
** letter and position as new parameters.
*/
(deffunction assertLetter (?l ?p)
   (assert (Letter (c ?l) (p ?p)))
   (return)
)

/*
** assertLetters takes in a list ?l of singular letters 
** and then calls function assertLetter on each letter in 
** the list.
*/
(deffunction assertLetters (?l)
   (for (bind ?i 1) (<= ?i (length$ ?l)) (++ ?i)
      (assertLetter (nth$ ?i ?l) ?i)
   )
   (return)
)

/*
** slice$ takes in a string, uses the jess explode$ function to remove all
** whitespace, and adds each character from each word into a list. That
** list is then returned.
*/
(deffunction slice$ (?x) 
   (bind ?lis1 (explode$ ?x))
   (bind ?lis2 (create$ ()))
   
   (foreach ?s ?lis1
      (for (bind ?i 1) (<= ?i (str-length ?s)) (++ ?i)
         (bind ?lis2 (insert$ ?lis2 (+ 1 (length$ ?lis2)) (sub-string ?i ?i ?s)))     
      )
   )
   
   (return ?lis2)
)

/*
** check determines if number ?x is less than global variable
** ?*max_length*. If ?x is less, then check returns true. Otherwise,
** check returns false.
*/
(deffunction check (?x)
   (return (< (str-length ?x) ?*max_length*))
)

/*
** createRule dynamically creates a rule for a word with length
** ?x which outputs each anagram of the word by adding letters with
** unique positions. 
*/
(deffunction createRule (?len)
   (bind ?temp "(defrule rule ")
   
   (for (bind ?i 1) (<= ?i ?len) (++ ?i)
      (bind ?temp (str-cat ?temp "(Letter (c ?l" ?i ") (p ?p" ?i))
      
      (for (bind ?j (- ?i 1)) (>= ?j 1) (-- ?j)
         (bind ?temp (str-cat ?temp " &~?p" ?j))
      )
      
      (bind ?temp (str-cat ?temp ")) "))
   )
   
   (bind ?temp (str-cat ?temp "=> (printout t "))
   
   (for (bind ?i 1) (<= ?i ?len) (++ ?i)
      (bind ?temp (str-cat ?temp "?l" ?i " "))
   )
   
   (bind ?temp (str-cat ?temp "\" \" crlf))"))
   (build ?temp)
)

/*
** main takes in a user's input word of length below 10 and binds it
** to ?readerinput. Then, it calls createRule on the length of ?readerinput
** to create the anagrams of the word. assertLetters is called on a list of
** the letters in ?readerinput to declare them as facts, and then the rule fires
** to output all the anagrams of ?readerinput.
*/
(deffunction main ()
   (bind ?readerinput (ask "Enter a string under 10 characters: "))
   (while (not (check ?readerinput)) do
      (bind ?readerinput (ask "Invalid input. Enter a string under 10 characters: "))
   )
   (createRule (str-length ?readerinput))
   (bind ?lis (slice$ ?readerinput))
   (assertLetters ?lis)   
   (run)
   (reset)
   (return)
)
