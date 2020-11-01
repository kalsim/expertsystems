/*
** Montek Kalsi
** January 30, 2019
**
** Collection of JESS functions used to emulate an alphabtic histogram
**
** slice$           - breaks up a string into a list of its characters
** count$           - counts the number of each letter within a list of characters
** histogram        - takes in a user's string input and outputs a count of each character
** 
*/

(clear)
(reset)
(batch utilities_v2.clp)
(batch asciiToChar.clp)

(defglobal ?*a* = 97)
(defglobal ?*A* = 65)
(defglobal ?*z* = 122)
(defglobal ?*Z* = 90)

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
** The function count$ takes in a list of characters and converts
** them to ascii to determine the frequency of each character in the list.
** It counts the number of occurrences of letters a through z in a list of length 26,
** and it outputs that list.
*/
(deffunction count$ (?x)
   (bind ?lis (create$))
   (bind ?ascii (asciiList$))
   (for (bind ?i 1) (<= ?i 256) (++ ?i)
      (bind ?lis (insert$ ?lis 1 0))
   )
   (foreach ?char ?x
      (bind ?ind (member$ ?char ?ascii))
      (bind ?lis (replace$ ?lis ?ind ?ind (+ 1 (nth$ ?ind ?lis))))
   )

   (bind ?lis2 (create$ ()))
   (for (bind ?i 1) (<= ?i 27) (++ ?i)
      (bind ?lis2 (insert$ ?lis2 1 0))
   )

   (for (bind ?i ?*a*) (<= ?i (+ ?*z* 1)) (++ ?i)
      (bind ?ind (+ (- ?i ?*a*) 1))
      (bind ?lis2 (replace$ ?lis2 ?ind ?ind (+ (nth$ ?i ?lis) (nth$ ?ind ?lis2))))
   )

   (for (bind ?i ?*A*) (<= ?i (+ ?*Z* 1)) (++ ?i)
      (bind ?ind (+ (- ?i ?*A*) 1))
      (bind ?lis2 (replace$ ?lis2 ?ind ?ind (+ (nth$ ?i ?lis) (nth$ ?ind ?lis2))))
   )
   
   (return ?lis2)
)

/*
** The function histogram takes in the user's input of a string, stores it,
** uses slice$ to break it up, then calls count$ on the broken up list of characters.
** The values output by count$ are then displayed next to their corresponding letters.
*/
(deffunction histogram ()
   (bind ?readerinput (askline "Enter ASCII text: "))
   (bind ?l1 (slice$ ?readerinput))
   (bind ?l2 (count$ ?l1))
   
   (for (bind ?i 2) (<= ?i (length$ ?l2)) (++ ?i)
      (printline (str-cat (toChar (+ ?*a* (- ?i 2))) ": " (nth$ ?i ?l2)))
   )
   
   (return)
)
