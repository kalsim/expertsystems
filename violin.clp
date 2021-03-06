/*
** Montek Kalsi
** May 21, 2019
**
** Collection of Jess functions and rules to pick violin pieces based upon the user's skill
** and desire. Currently consists of mostly classical pieces.
*/

(clear)
(reset)

(defglobal ?*asked* = 1)           ; number of questions asked so far

/*
** List of facts that can be backwards chained. These
** are the various characteristics which determine the piece to output.
*/

(do-backward-chaining length)
(do-backward-chaining years)                ; how long the user has played for
(do-backward-chaining difficulty)           ; the difficulty of the piece he or she desires
(do-backward-chaining stops)                ; if the user can play double stops
(do-backward-chaining position)             ; if the user can shift positions
(do-backward-chaining fast)
(do-backward-chaining slow)
(do-backward-chaining accompaniment)
(do-backward-chaining orchestral)           ; if the accompaniment is orchestral or not
(do-backward-chaining genre)
(do-backward-chaining key)                  ; major or minor in this case
(do-backward-chaining movement)             ; if the user is satisfied with receiving excerpts from lengthy pieces
(do-backward-chaining virtuosic)
(do-backward-chaining period)



/*
** The following rules are backward chaining rules for each trait. They fire and vary 
** between asserting traits as yes, no, or maybe or within a range of integers. 
** They prompt the user and ask about preferences to determine which piece would be 
** best suited for the user's interests, asserts facts based
** on the responses. Inferences are made as well, as if a user is a beginner, they
** typically don't play virtuosic pieces.
*/

(defrule need-length-rule
   (need-length ?)
   (movement no)
=>
   (bind ?a (askn "Do you want your piece to be 1 - under 5 minutes, 2 - 5 to 30 minutes, or 3 - over 30 minutes? Enter 4 if you have no preference. " 1 4))
   (if (= ?a 4) then
      (assert (length 1))
      (assert (length 2))
      (assert (length 3))
   else
      (assert (length ?a))
   )
)

(defrule need-years-rule
   (need-years ?)
=>
   (bind ?a (askn "How long have you played the violin? 1 - less than a year of playing, 2 - 1 to 3 years, and 3 - 3+ years. " 1 3))
   (if (= ?a 1) then
      (assert (difficulty no))
      (assert (stops no))
      (assert (position no))
   else
      (if (= ?a 3) then
         (bind ?a 2)
      )
      (assert (years ?a))
   )
)

(defrule need-difficulty-rule
   (need-difficulty ?)
=>
   (bind ?a (ask "Do you want a challenging piece? Answer with yes, no, or ? if you don't care. "))
   (if (= ?a maybe) then
      (assert (difficulty yes))
      (assert (difficulty no))
   else
      (assert (difficulty ?a))
      (if (= ?a no) then
         (assert (virtuosic no))
         (assert (years 1))
      )
   )
)


(defrule need-stops-rule
   (need-stops ?)
=>
   (bind ?a (ask "Can you smoothly play double stops? Answer with yes, no, or ? for unsure. "))
   (if (= ?a maybe) then
      (assert (stops yes))
      (assert (stops no))
   else
      (assert (stops ?a))
      (if (= ?a no) then
         (assert (virtuosic no))
      )
   )
)

(defrule need-position-rule
   (need-position ?)
=>
   (bind ?a (ask "Can you smoothly shift positions? Answer with yes, no, or ? for unsure. "))
   (if (= ?a maybe) then
      (assert (position yes))
      (assert (position no))
   else
      (assert (position ?a))
      (if (= ?a no) then
         (assert (virtuosic no))
      )
   )
)

(defrule need-fast-rule
   (need-fast ?)
=>
   (bind ?a (ask "Do you want fast parts in the piece? Answer with yes, no, or ? for unsure. "))
   (if (= ?a maybe) then
      (assert (fast yes))
      (assert (fast no))
   else
      (assert (fast ?a))
   )
)

(defrule need-slow-rule
   (need-slow ?)
=>
   (bind ?a (ask "Do you want slow parts in the piece? Answer with yes, no, or ? for unsure. "))
   (if (= ?a maybe) then
      (assert (slow yes))
      (assert (slow no))
   else
      (assert (slow ?a))
   )
)

(defrule need-accompaniment-rule
   (need-accompaniment ?)
=>
   (bind ?a (ask "Do you want accompaniment for the piece? Answer with yes, no, or ? for unsure. "))
   (if (= ?a maybe) then
      (assert (accompaniment yes))
      (assert (accompaniment no))
   else
      (if (= ?a no) then
         (assert (orchestral no))
      )
      (assert (accompaniment ?a))
   )
)

(defrule need-orchestral-rule
   (need-orchestral ?)
   (accompaniment yes)
=>
   (bind ?a (ask "Do you want orchestral accompaniment? Answer with yes, no, or ? for unsure. "))
   (if (= ?a maybe) then
      (assert (orchestral yes))
      (assert (orchestral no))
   else
      (assert (orchestral ?a))
   )
)


(defrule need-genre-rule
   (need-genre ?)
=>
   (bind ?a (askn "What genre would you prefer? 1 - pop, 2 - classical, 3 - jazz, 4 - blues, 5 - other/unsure " 1 5))
   (if (= ?a 5) then
      (assert (genre 1))
      (assert (genre 2))
      (assert (genre 3))
      (assert (genre 4))
      (assert (genre 5))
   else
      (assert (genre ?a))
   )
)

(defrule need-key-rule
   (need-key ?)
=>
   (bind ?a (askn "Would you like a predominantly 1 - major piece, 2 - minor piece, or 3 - unsure/doesn't matter ? " 1 3))
   (if (= ?a 3) then
      (assert (key 1))
      (assert (key 2))
   else
      (assert (key ?a))
   )
)

(defrule need-movement-rule
   (need-movement ?)
=>
   (bind ?a (ask "Would you be fine with a movement or excerpt from your piece, or do you intend to play the full piece? 
   Answer with yes, no, or ? for unsure. "))
   (if (or (= ?a yes) (= ?a maybe)) then
      (assert (movement yes))
      (assert (length 1))
      (assert (length 2))
      (assert (length 3))
   else
      (assert (movement no))
   )
)

(defrule need-virtuosic-rule
   (need-virtuosic ?)
=>
   (bind ?a (ask "Do you want a virtuosic piece aimed to impress? You must be skilled to play these pieces. Answer with yes, no, or ? for unsure. "))
   (if (= ?a maybe) then
      (assert virtuosic yes)
      (assert virtuosic no)
   else
      (assert (virtuosic ?a))
   )
)

(defrule need-period-rule
   (need-period ?)
   (genre 2)
=>
   (bind ?a (askn "Enter the time period from which you want the piece: 1 - baroque, 2 - classical, 3 - romantic, 4 - contemporary, or 5 - unsure." 1 5))
   (if (= ?a 5) then
      (assert (period 1))
      (assert (period 2))
      (assert (period 3))
      (assert (period 4))
   else
      (assert (period ?a))
   )
)

/*
** Rules for assigning facts to pieces. These are the characteristics associated
** with each piece used for identification and pattern matching. 
** On the left hand side, the pattern matching occurs, and if all the conditions are
** met, the right hand side ends the game and outputs the piece. The numerical patterns
** match with the specifications of the need rules.
*/

(defrule espagnole
   (length 3)
   (years 2)
   (difficulty yes)
   (stops yes)
   (position yes)
   (fast yes)
   (genre 2)
   (period 3)
   (virtuosic no)
=>
   (printout t "Your piece is Symphonie Espagnole by Lalo." crlf)
   (gameover “c”) 
)

(defrule despacito
   (length 1)
   (genre 1)
=>
   (printout t "Your piece is Despacito." crlf)
   (gameover “c”) 
)

(defrule louis
   (genre 4)
=>
   (printout t "Your piece is St. Louis Blues." crlf)
   (gameover “c”) 
)

(defrule jazz
   (genre 3)
=>
   (printout t "Your piece is Gypsy Jazz Violin - All Of Me" crlf)
   (gameover “c”) 
)

(defrule minuet
   (difficulty no)
   (length 1)
   (genre 2)
   (period 1)
=>
   (printout t "Your piece can be one of Bach's minuets found in the Suzuki books." crlf)
   (gameover “c”) 
)

(defrule Zigeunerweisen
   (length 2)
   (years 2)
   (difficulty yes)
   (stops yes)
   (position yes)
   (fast yes)
   (genre 2)
   (period 3)
   (virtuosic yes)
=>
   (printout t "Your piece is Zigeunerweisen." crlf)
   (gameover “c”) 
)

(defrule meditation
   (length 1)
   (years 2)
   (position yes)
   (slow yes)
   (genre 2)
   (period 3)
   (virtuosic yes)
   (accompaniment yes)
=>
   (printout t "Your piece is Meditation from Thais." crlf)
   (gameover “c”) 
)

(defrule caprice
   (length 1)
   (years 2)
   (difficulty yes)
   (stops yes)
   (position yes)
   (fast yes)
   (genre 2)
   (period 3)
   (virtuosic yes)
=>
   (printout t "Your piece is Paganini's Caprice 24." crlf)
   (gameover “c”) 
)

/*
** This function asks the user the question ?question, ensures it's a valid
** response, and returns the response in either a yes, no, or maybe form.
*/
(deffunction ask (?question)
   (printout t (str-cat (str-cat ?*asked* ". ") ?question) crlf)
   (bind ?input (userinput (read)))
   (while (not (validate ?input)) do
      (printout t "Invalid input; please enter y for yes, n for no, or ? for maybe." crlf)
      (bind ?input (userinput (read)))
   )
   (bind ?*asked* (+ ?*asked* 1))
   (return ?input)
)

/*
** Similar to ask, this function asks the user the question ?question, but expects an integer
** response. The response must be within the two bounds passed in as parameters; if it's not, the user
** is prompted to provide another response. Once the user inputs a valid integer, askn 
** returns the response.
*/
(deffunction askn (?question ?bound1 ?bound2)
   (printout t (str-cat (str-cat ?*asked* ". ") ?question) crlf)
   (bind ?input (read))
   (while (not (and (integerp ?input) (>= ?input ?bound1) (<= ?input ?bound2))) do
      (printout t "Invalid input; please enter an integer in the range provided." crlf)
      (bind ?input (read))
   )
   (bind ?*asked* (+ ?*asked* 1))
   (return ?input)
)


/*
** Modifies the input ?x to fit the proper format of yes, no, and maybe.
** It takes the first character from the string ?x, and if it is y, n, or ?,
** the function outputs yes, no, or maybe respectively.
*/
(deffunction userinput (?x)
   (if (= (sub-string 1 1 (lowcase ?x)) "y") then
      (bind ?x yes)
   )
   (if (= (sub-string 1 1 (lowcase ?x)) "n") then
      (bind ?x no)
   )
   (if (= (sub-string 1 1 ?x) "?") then
      (bind ?x maybe)
   )
   (return ?x)
)

/*
** Validate ensures that the input is legitimate.
** Parameter ?x must be either yes, no, or maybe.
** If ?x doesn’t fit this description, validate outputs false.
*/
(deffunction validate (?x)
   (if (or (= ?x yes) (= ?x no) (= ?x maybe)) then
      (bind ?x TRUE)
   else
      (bind ?x FALSE)
   )
   (return ?x)
)

/*
** Function which starts the program and runs the system. It initially
** calls reset to clear the facts, and prints the introductory message. Then, the
** program is run, and it has an empty return.
*/
(deffunction play ()
   (reset)
   (printout t "Welcome to my violin piece picker! Enter what you are looking for, and I can help you find a piece! When the game ends, type (play) to try again!" crlf)
   (run)
   (return)
)

/*
** When called, gameover ends the game with a specific output depending on
** whether the computer has found a piece or not. If parameter ?x is “c”, then the
** computer has made a proposition. If it is “h”, that means the computer was unable to 
** find a piece satisfying the user's desires.
** Afterwards, the program halts, and the function has an empty return.
*/
(deffunction gameover (?x)
   (if (= ?x "c") then
      (printout t "Thank you for trying my expert system! Type (play) to play again." crlf)
   elif (= ?x "h") then
      (printout t "Sorry, I have no reccomendations that match your constraints. Type (play) to try again." crlf)
   )
   (halt)
   (return)
)

/*
** If all the rules fire and no piece can be found, gameend is fired
** and calls gameover to end the program. Its low salience ensures it is called
** last after all the rules are fired.
*/
(defrule gameend
   (declare (salience -100))
=>
   (gameover "h")
)

(play)
