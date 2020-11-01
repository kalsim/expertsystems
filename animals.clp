/*
** Montek Kalsi
** May 1, 2019
**
** Collection of Jess functions and rules which attempt to guess an animal which the user is thinking of by asking questions regarding
** then traits of the user’s animal. The user can respond with yes, no, or maybe, winning if the computer can’t discover then animal or
** it takes longer than 20 questions to guess. The computer wins if it guesses the user’s animal successfully.
*/

(clear)
(reset) 



(defglobal ?*MAXQUESTIONS* = 20)  ; maximum number of questions which can be asked
(defglobal ?*asked* = 1)          ; number of questions asked so far


/*
** List of facts that can be backwards chained. These
** are the various characteristics which the animals can exhibit.
*/

(do-backward-chaining vertebrate)
(do-backward-chaining land)
(do-backward-chaining seen)
(do-backward-chaining mammal)
(do-backward-chaining zoo)
(do-backward-chaining water)
(do-backward-chaining equine)
(do-backward-chaining eaten)
(do-backward-chaining northamerica)
(do-backward-chaining marsupial)
(do-backward-chaining tall)
(do-backward-chaining fly)
(do-backward-chaining quadruped)
(do-backward-chaining fast)
(do-backward-chaining black)
(do-backward-chaining white)
(do-backward-chaining carnivorous)
(do-backward-chaining endangered)
(do-backward-chaining farm)


/*
** The following rules are backward chaining rules for each trait. They fire
** to determine which traits are yes, no, or maybe. They prompt the user and ask 
** whether the animal they have in mind contains the trait, and asserts facts based
** on the responses. Inferences are made as well, as if an animal can fly, it is not
** a quadruped according to this knowledge base. 
*/

(defrule need-vertebrate-rule
   (need-vertebrate ?)
=>
   (bind ?a (ask "Is your animal a vertebrate? "))
   (if (= ?a maybe) then
      (assert (vertebrate yes))
      (assert (vertebrate no))
   else
      (assert (vertebrate ?a))
      (if (= ?a no) then                                            
        (assert (mammal no))
        (assert (equine no))
        (assert (marsupial no))
        (assert (quadruped no))
      )
   )
)

(defrule need-land-rule
   (need-land ?)
=>
   (bind ?a (ask "Can this animal live on land? "))
   (if (= ?a maybe) then
      (assert (land yes))
      (assert (land no))
   else
      (assert (land ?a))
   )
)

(defrule need-seen-rule
   (need-seen ?)
=>
   (bind ?a (ask "Is this animal typically seen by the average person? "))
   (if (= ?a maybe) then
      (assert (seen yes))
      (assert (seen no))
   else
      (assert (seen ?a))
      ; if it's yes do all the inferences
   )
)

(defrule need-mammal-rule
   (need-mammal ?)
=>
   (bind ?a (ask "Is this animal a mammal? "))
   (if (= ?a maybe) then
      (assert (mammal yes))
      (assert (mammal no))
   else
      (assert (mammal ?a))
      (if (= ?a no) then
         (assert (equine no))
         (assert (marsupial no))
         (assert (quadruped no))      
      )
   )
)

(defrule need-zoo-rule
   (need-zoo ?)
=>
   (bind ?a (ask "Is this animal found in zoos as an exhibit? "))
   (if (= ?a maybe) then
      (assert (zoo yes))
      (assert (zoo no))
   else
      (assert (zoo ?a))
      (if (= ?a yes) then
         (assert (water no))
      )
   )
)

(defrule need-water-rule
   (need-water ?)
=>
   (bind ?a (ask "Can this animal live in water? "))
   (if (= ?a maybe) then
      (assert (water yes))
      (assert (water no))
   else
      (assert (water ?a))
      (if (= ?a yes) then
         (assert (fly no))
         (assert (equine no))
         (assert (marsupial no))
         (assert (farm no))
      )
   )
)

(defrule need-equine-rule
   (need-equine ?)
=>
   (bind ?a (ask "Is this animal equine? "))
   (if (= ?a maybe) then
      (assert (equine yes))
      (assert (equine no))
   else
      (assert (equine ?a))
      (if (= ?a yes) then
         (assert (fly no))
         (assert (quadruped yes))
         (assert (eaten no))
      )
   )
)

(defrule need-eaten-rule
   (need-eaten ?)
=>
   (bind ?a (ask "Is this animal typically eaten by humans? "))
   (if (= ?a maybe) then
      (assert (eaten yes))
      (assert (eaten no))
   else
      (assert (eaten ?a))
      (if (= ?a yes) then
         (assert (endangered no))
      )
   )
)

(defrule need-northamerica-rule
   (need-northamerica ?)
=>
   (bind ?a (ask "Is this animal found in North America? "))
   (if (= ?a maybe) then
      (assert (northamerica yes))
      (assert (northamerica no))
   else
      (assert (northamerica ?a))
   )
)

(defrule need-marsupial-rule
   (need-marsupial ?)
=>
   (bind ?a (ask "Is this animal a marsupial? "))
   (if (= ?a maybe) then
      (assert (marsupial yes))
      (assert (marsupial no))
   else
      (assert (marsupial ?a))
      (if (= ?a yes) then
         (assert (fly no))
         (assert (equine no))
         (assert (water no))
         (assert (quadruped no))
         (assert (tall yes))
         (assert (farm no))
      )
   )
)

(defrule need-tall-rule
   (need-tall ?)
=>
   (bind ?a (ask "Is this animal taller/longer than an average human? "))
   (if (= ?a maybe) then
      (assert (tall yes))
      (assert (tall no))
   else
      (assert (tall ?a))
      (if (= ?a yes) then
         (assert (fly no))
      )
      (if (= ?a no) then
         (assert (equine no))
         (assert (marsupial no))
         (assert (quadruped yes))
      )
   )
)

(defrule need-fly-rule
   (need-fly ?)
=>
   (bind ?a (ask "Can the animal fly? "))
   (if (= ?a maybe) then
      (assert (fly yes))
      (assert (fly no))
   else
      (assert (fly ?a))
      (if (= ?a yes) then
         (assert (equine no))
         (assert (water no))
         (assert (tall no))
      )
   )
)

(defrule need-quadruped-rule
   (need-quadruped ?)
=>
   (bind ?a (ask "Is this animal a quadruped? "))
   (if (= ?a maybe) then
      (assert (quadruped yes))
      (assert (quadruped no))
   else
      (assert (quadruped ?a))
   )
)

(defrule need-fast-rule
   (need-fast ?)
=>
   (bind ?a (ask "Can this animal move faster than humans? "))
   (if (= ?a maybe) then
      (assert (fast yes))
      (assert (fast no))
   else
      (assert (fast ?a))
   )
)

(defrule need-black-rule
   (need-black ?)
=>
   (bind ?a (ask "Does it typically have a black color on it? "))
   (if (= ?a maybe) then
      (assert (black yes))
      (assert (black no))
   else
      (assert (black ?a))
   )
)

(defrule need-white-rule
   (need-white ?)
=>
   (bind ?a (ask "Does it typically have a white color on it? "))
   (if (= ?a maybe) then
      (assert (white yes))
      (assert (white no))
   else
      (assert (white ?a))
   )
)

(defrule need-carnivorous-rule
   (need-carnivorous ?)
=>
   (bind ?a (ask "Is this animal carnivorous? "))
   (if (= ?a maybe) then
      (assert (carnivorous yes))
      (assert (carnivorous no))
   else
      (assert (carnivorous ?a))
      (if (= ?a yes) then
         (assert (equine no))
      )
   )
)

(defrule need-endangered-rule
   (need-endangered ?)
=>
   (bind ?a (ask "Is this animal endangered? "))
   (if (= ?a maybe) then
      (assert (endangered yes))
      (assert (endangered no))
   else
      (assert (endangered ?a))
      (if (= ?a yes) then
         (assert (eaten no))
      )
   )
)

(defrule need-farm-rule
   (need-farm ?)
=>
   (bind ?a (ask "Can this animal be found on a farm as a farm animal? "))
   (if (= ?a maybe) then
      (assert (farm yes))
      (assert (farm no))
   else
      (assert (farm ?a))
      (if (= ?a yes) then
         (assert (water no))
      )
   )
)

/*
** Rules for assigning facts to animals. These are the characteristics
** associated with each animal used for identification and pattern matching.
** On the left hand side, the pattern matching occurs, and if all the conditions are
** met, the right hand side ends the game and guesses the animal.
*/

(defrule dolphin
   (vertebrate yes)
   (land no)
   (mammal yes)
   (water yes)
   (northamerica yes)
   (tall yes)
   (fast yes)
=>
   (printout t "The animal is a dolphin." crlf)
   (gameover “c”) 
)

(defrule Kangaroo
   (marsupial yes)
   (vertebrate yes)
   (land yes)
   (seen no)
   (mammal yes)
   (eaten no)
   (northamerica no)
   (tall yes)
=>
   (printout t "The animal is a Kangaroo." crlf)
   (gameover “c”) 
)

(defrule Panda
   (vertebrate yes)
   (land yes)
   (seen no)
   (mammal yes)
   (zoo yes)
   (northamerica no)
   (tall yes)
   (quadruped yes)
   (black yes)
   (white yes)
   (endangered yes)
=>
   (printout t "The animal is a Panda." crlf)
   (gameover “c”) 
)

(defrule Chicken
   (vertebrate yes)
   (land yes)
   (seen yes)
   (mammal no)
   (zoo yes)
   (eaten yes)
   (northamerica yes)
   (farm yes)
=>
   (printout t "The animal is a Chicken." crlf)
   (gameover “c”) 
)

(defrule Squirrel
   (vertebrate yes)
   (land yes)
   (seen yes)
   (mammal yes)
   (zoo no)
   (northamerica yes)
   (tall no)
   (fly no)
=>
   (printout t "The animal is a Squirrel." crlf)
   (gameover “c”) 
)

(defrule Blackbear
   (vertebrate yes)
   (land yes)
   (seen no)
   (mammal yes)
   (water no)
   (northamerica yes)
   (marsupial no)
   (tall yes)
   (fly no)
   (quadruped yes)
   (fast no)
   (black yes)
   (white no)
   (carnivorous yes)
   (endangered yes)
   (farm no)
=>
   (printout t "The animal is a Blackbear." crlf)
   (gameover “c”) 
)

(defrule Arcticfox
   (vertebrate yes)
   (land yes)
   (seen no)
   (mammal yes)
   (zoo no)
   (water no)
   (northamerica no)
   (quadruped yes)
   (fast yes)
   (black no)
   (white yes)
   (endangered yes)
=>
   (printout t "The animal is an Arctic Fox." crlf)
   (gameover “c”) 
)

(defrule Shrimp
   (vertebrate no)
   (seen yes)
   (water yes)
   (eaten yes)
   (northamerica yes)
=>
   (printout t "The animal is a Shrimp." crlf)
   (gameover “c”) 
)

(defrule Salmon
   (vertebrate yes)
   (seen yes)
   (water yes)
   (eaten yes)
   (northamerica yes)
   (tall no)
   (fast yes)
=>
   (printout t "The animal is a Salmon." crlf)
   (gameover “c”) 
)

(defrule Crow
   (vertebrate yes)
   (land yes)
   (seen yes)
   (zoo no)
   (northamerica yes)
   (tall no)
   (fly yes)
   (black yes)
  =>
   (printout t "The animal is a Crow." crlf)
   (gameover “c”) 
)

(defrule Lemur
   (vertebrate yes)
   (land yes)
   (seen no)
   (mammal yes)
   (zoo no)
   (eaten no)
   (northamerica no)
   (marsupial no)
   (black yes)
   (white yes)
   (endangered yes)
   (quadruped no)
=>
   (printout t "The animal is a Lemur." crlf)
   (gameover “c”) 
)

(defrule Cow
   (vertebrate yes)
   (land yes)
   (mammal yes)
   (eaten yes)
   (northamerica yes)
   (tall yes)
   (quadruped yes)
   (farm yes)
=>
   (printout t "The animal is a Cow." crlf)
   (gameover “c”) 
)

(defrule Jellyfish
   (vertebrate no)
   (seen no)
   (water yes)
   (eaten no)
   (tall no)
   (fast no)
   (endangered no)
=>
   (printout t "The animal is a Jellyfish." crlf)
   (gameover “c”) 
)

(defrule Goldfish
   (vertebrate yes)
   (seen yes)
   (water yes)
   (land no)
   (northamerica yes)
   (tall no)
=>
   (printout t "The animal is a Goldfish." crlf)
   (gameover “c”) 
)

(defrule Platypus
   (vertebrate yes)
   (land yes)
   (seen no)
   (mammal yes)
   (water yes)
   (eaten no)
   (northamerica no)
   (marsupial no)
   (tall no)
   (fly no)
   (quadruped yes)
   (black yes)
   (white yes)
=>
   (printout t "The animal is a Platypus." crlf)
   (gameover "c")
)

(defrule Cheetah
   (vertebrate yes)
   (land yes)
   (seen no)
   (mammal yes)
   (zoo yes)
   (eaten no)
   (northamerica no)
   (tall yes)
   (quadruped yes)
   (fast yes)
   (carnivorous yes)
   (endangered no)
   (black yes)
=>
   (printout t "The animal is a Cheetah." crlf)
   (gameover “c”)
)

(defrule Tiger
   (vertebrate yes)
   (land yes)
   (seen no)
   (mammal yes)
   (zoo yes)
   (water no)
   (equine no)
   (eaten no)
   (northamerica no)
   (marsupial no)
   (tall yes)
   (fly no)
   (quadruped yes)
   (fast yes)
   (black yes)
   (white yes)
   (carnivorous yes)
   (endangered yes)
=>
   (printout t "The animal is a Tiger." crlf)
   (gameover “c”) 
)

(defrule Zebra
   (vertebrate yes)
   (land yes)
   (seen no)
   (mammal yes)
   (zoo yes)
   (water no)
   (equine yes)
   (eaten no)
   (northamerica no)
   (tall yes)
   (quadruped yes)
   (fast yes)
   (black yes)
   (white yes)
   (carnivorous no)
   (endangered no)
   (farm no)
=>
   (printout t "The animal is a Zebra." crlf)
   (gameover “c”) 
)

(defrule Lion
   (vertebrate yes)
   (land yes)
   (mammal yes)
   (zoo yes)
   (eaten no)
   (northamerica no)
   (tall yes)
   (quadruped yes)
   (fast yes)
   (carnivorous yes)
   (endangered yes)
   (black no)
   (white no)
=>
   (printout t "The animal is a Lion." crlf)
   (gameover “c”) 
)

(defrule Alligator
   (vertebrate yes)
   (land yes)
   (zoo yes)
   (water yes)
   (northamerica yes)
   (tall yes)
   (quadruped yes)
   (carnivorous yes)
=>
   (printout t "The animal is a Alligator." crlf)
   (gameover “c”) 
)



/*
** This function asks the user the question ?question, ensures it’s a valid response through
** the validate function, and returns the response in a yes, no, or maybe form. If the asked
** questions exceeds the maximum of 20, then gameover is called to end the game.
*/
(deffunction ask (?question)
   (if (> ?*asked* ?*MAXQUESTIONS*) then
      (gameover "h")
   )
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
** Function which starts the program and runs the game. It initially
** calls reset to clear the facts, and prints the introductory message. Then, the
** program is run, and it has an empty return.
*/ 
(deffunction play ()
   (reset)
   (printout t "Welcome to my 20 questions game! Think of an animal, and I will try to guess it! Answer yes, no, or ? if you don't know for the questions I will ask. When the game ends, type (play) to try again!" crlf)
   (run)
   (return)
)

/*
** When called, gameover ends the game with a specific output depending on
** whether the computer guessed an animal or not. If parameter ?x is “c”, then the
** computer has made a guess. If it is “h”, then the human wins as the computer couldn’t
** make the guess. Afterwards, the program halts, and the function has an empty return.
*/
(deffunction gameover (?x)
   (if (= ?x "c") then
      (printout t "I hope I guessed it! Thanks for playing! Type (play) to play again." crlf)
   elif (= ?x "h") then
      (printout t "I couldn't think of your animal. Sorry! Do (play) to play again." crlf)
   )
   (halt)
   (return)
)

/*
** If all the rules fire and no animal can be found, gameend is fired
** and calls gameover to end the program. Its low salience ensures it is called
** last after all the rules are fired.
*/
(defrule gameend
   (declare (salience -100))
=>
   (gameover "h")
)

(play)



