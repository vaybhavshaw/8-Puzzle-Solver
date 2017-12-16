;;;; VAYBHAV SHAW	
;;;; shaw0162@umn.edu
;;;; LISP ASSIGNMENT QUESTION 2
;;;; 8 puzzle problem
;;;; December 7, 2017

;;;;;;;;; INSTRUCTIONS TO RUN ;;;;;;;;;;
;; Navigate to the location of the file
;; RUN		clisp puzzle8f.lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;  Taking user input of the 8-Puzzle  ;;;;;;;;;;;;;;;;;;;;;;;
(format t "~%Enter the 8 puzzle in the format ((E a b) (c d e) (f g h)) ~%" )
(format t "Example -  ((E 1 3) (4 2 5) (7 8 6)) ~%" )
(format t "Where E is the EMPTY TILE ~%~%" )
(defvar initialPuzzle (read)) 

;;; Checking whether the user input is a list or not
(if(not(listp initialPuzzle))
	(progn
		(print "Your input is not a list")
		(exit)
	)
)

(defvar Epos 0) ;; Position of E
(defvar nMisplaced 0) ;; count of number of misplaced tiles
(defvar swap-list '()) ;; positions that would be swapped depending on the position of E
(defvar swap-states '()) ;; states generated on swapping with E
(defvar lowest-heuristic '()) ;; stores the list with the lowest heuristic
(defvar closed-list '()) ;; closed list in which the traveled states are added
(defvar open-list '()) ;; open list working in A* concept
(defvar glist '()) ;; stores swapped combinations
(defvar counter 0) ;; counts the number of nodes expanded


;;; Finding Position of E in an unserialized and setting it to Epos
(defun find-pos()	
	(if(eq 'E (car(car initialPuzzle)))
		(setq Epos 0)
	)
	(if(eq 'E (cadr(car initialPuzzle)))
		(setq Epos 1)
	)
	(if(eq 'E (caddr(car initialPuzzle)))
		(setq Epos 2)
	)
	(if(eq 'E (car(cadr initialPuzzle)))
		(setq Epos 3)
	)
	(if(eq 'E (cadr(cadr initialPuzzle)))
		(setq Epos 4)
	)
	(if(eq 'E (caddr(cadr initialPuzzle)))
		(setq Epos 5)
	)
	(if(eq 'E (car(caddr initialPuzzle)))
		(setq Epos 6)
	)
	(if(eq 'E (cadr(caddr initialPuzzle)))
		(setq Epos 7)
	)
	(if(eq 'E (caddr(caddr initialPuzzle)))
		(setq Epos 8)
	)
)

;;; Finding Position of E in a selialized list and setting it to Epos
(defun find-pos1(initialPuzzle)
	(if(eq 'E (nth 0 initialPuzzle))
		(setq Epos 0)
	)
	(if(eq 'E (nth 1 initialPuzzle))
		(setq Epos 1)
	)
	(if(eq 'E (nth 2 initialPuzzle))
		(setq Epos 2)
	)
	(if(eq 'E (nth 3 initialPuzzle))
		(setq Epos 3)
	)
	(if(eq 'E (nth 4 initialPuzzle))
		(setq Epos 4)
	)
	(if(eq 'E (nth 5 initialPuzzle))
		(setq Epos 5)
	)
	(if(eq 'E (nth 6 initialPuzzle))
		(setq Epos 6)
	)
	(if(eq 'E (nth 7 initialPuzzle))
		(setq Epos 7)
	)
	(if(eq 'E (nth 8 initialPuzzle))
		(setq Epos 8)
	)
)

;;; Store in nMisplaced, the number of misplaced tiles in a serialised list
(defun misplaced-tiles()
	(setf nMisplaced 0)
	(if(not(eq 1 (car(car initialPuzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 2 (cadr(car initialPuzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 3 (caddr(car initialPuzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 4 (car(cadr initialPuzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 5 (cadr(cadr initialPuzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 6 (caddr(cadr initialPuzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 7 (car(caddr initialPuzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 8 (cadr(caddr initialPuzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
)

;;; Store in nMisplaced, the number of misplaced tiles in an unserialised list
(defun misplaced-tiles1(Puzzle)
	(setf nMisplaced 0)
	(if(not(eq 1 (car Puzzle)))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 2 (cadr Puzzle)))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 3 (caddr Puzzle)))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 4 (cadddr Puzzle)))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 5 (car(nthcdr 4 Puzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 6 (car(nthcdr 5 Puzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 7 (car(nthcdr 6 Puzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
	(if(not(eq 8 (car(nthcdr 7 Puzzle))))
		(setq nMisplaced (+ nMisplaced 1))
	)
)

;;; Function to find the positions in the puzzle that would be swapped with E
(defun generate-position(puzzle pos)
	(setf swap-list '())
	(if(= Epos 0)
		(push '(1 3) swap-list)
	)
	(if(= Epos 1)
		(push '(0 2 4) swap-list)
	)
	(if(= Epos 2)
		(push '(1 5) swap-list)
	)
	(if(= Epos 3)
		(push '(0 4 6) swap-list)
	)
	(if(= Epos 4)
		(push '(1 3 5 7) swap-list)
	)
	(if(= Epos 5)
		(push '(2 4 8) swap-list)
	)
	(if(= Epos 6)
		(push '(3 7) swap-list)
	)
	(if(= Epos 7)
		(push '(6 8 4) swap-list)
	)
	(if(= Epos 8)
		(push '(5 7) swap-list)
	)
)

;;; Function to swap position of E with all elements in the swap-list and generate the child states
(defun swapfunc (list position positions-to-swap)
  (loop for position-to-swap in positions-to-swap
        for rotated-list = (copy-list list)
        do (rotatef (nth position rotated-list)
                    (nth position-to-swap rotated-list))
        collect rotated-list))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	 Functions of splitList ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1. Find the f(n), g(n) and h(n) for all the generated children states
;;; 2. Store the value of f(n) in the 9th index of the child node
;;; 3. Store the value of h(n) in the 10th index of the child node
;;; 4. Add child node to open list if it has not been traversed (not added to closed-list)
;;; 5. Sort the open-list in ascending order
;;; 6. Find the most optimal next node by chosing the node with the lowest function cost f(n) 
;;; 7a.If the chosen node has heuristic 0 (h(n)=0), then we have reached the goal state
;;; 7b.If the heuristic is not 0, then we call the function again with the new selected node 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun splitList(glist)	
	(setf counter (+ counter 1)) 
		(misplaced-tiles1 (car glist))
		(defparameter localHN1 nMisplaced)
		(defparameter localGN1 (+(- (car (last (car glist) 2)) (car (last (car glist) 1)))1))
		(defparameter localFN1 (+ localGN1 localHN1))
		(defparameter listbuild1 (car glist))
		(setf (nth 9 listbuild1) localFN1)
		(setf (nth 10 listbuild1) localHN1)
		(format t "Child 1 : ~a ~%" listbuild1)
		(defparameter lb1 (subseq listbuild1 0 9))
		(defparameter val1 (position lb1 closed-list :test #'equal))
		(if(eq val1 Nil)
			(push listBuild1 open-list)
		)



		(misplaced-tiles1 (cadr glist))
		(defparameter localHN2 nMisplaced)
		(defparameter localGN2 (+(- (car (last (cadr glist) 2)) (car (last (cadr glist) 1)))1))
		(defparameter localFN2 (+ localHN2 localGN2))
		(defparameter listbuild2 (cadr glist))
		(setf (nth 9 listbuild2) localFN2)
		(setf (nth 10 listbuild2) localHN2)
		(format t "Child 2 : ~a ~%" listbuild2)
		(defparameter lb2 (subseq listbuild2 0 9))
		(defparameter val2 (position lb2 closed-list
          :test #'equal))
		(if(eq val2 Nil)
			(push listbuild2 open-list)
		)


	(if (not(eq (caddr glist) Nil))
		(progn
			(misplaced-tiles1 (caddr glist))
			(defparameter localHN3 nMisplaced)
			(defparameter localGN3 (+(- (car (last (caddr glist) 2)) (car (last (caddr glist) 1)))1))
			(defparameter localFN3 (+ localGN3 localHN3))
			(defparameter listbuild3 (caddr glist))
			(setf (nth 9 listbuild3) localFN3)
			(setf (nth 10 listbuild3) localHN3)
			(format t "Child 3 : ~a ~%" listbuild3)
			(defparameter lb3 (subseq listBuild3 0 9))
			(defparameter val3 (position lb3 closed-list :test #'equal))
			(if(eq val3 Nil)
				(push listbuild3 open-list)
			)		
		)
	)

	(if (not(eq (cadddr glist) Nil))
		(progn
			(misplaced-tiles1 (cadddr glist))
			(defparameter localHN4 nMisplaced)
			(defparameter localGN4 (+(- (car (last (cadddr glist) 2)) (car (last (cadddr glist) 1)))1))
			(defparameter localFN4 (+ localGN4 localHN4))
			(defparameter listbuild4 (cadddr glist))
			(setf (nth 9 listbuild4) localFN4)
			(setf (nth 10 listbuild4) localHN4)
			(format t "Child 4 : ~a ~%" listbuild4)
			(defparameter lb4 (subseq listbuild4 0 9))
			(defparameter val4 (position lb4 closed-list
          	:test #'equal))
			(if(eq val4 Nil)
				(push listbuild4 open-list)
			)
		)
	)
	(sort open-list #'<= :key #'tenth)
	(defparameter  new-child (car open-list))	
	(defparameter fchild (nth 9 new-child))
	(defparameter sort-list '())
	(loop for x in open-list
		do (progn
				(defparameter nthval (nth 9 x))
				(if (= nthval fchild)
					(push x sort-list)
				)
			)
	)
	(defun eleventh (sort-list) (nth 10 sort-list))
	(sort sort-list #'<= :key #'eleventh)
	(setf new-child (car sort-list))
	(format t "Most Optimal Child ~a ~%" new-child)	
	(setq open-list (delete new-child open-list))
	(push (subseq new-child 0 9) closed-list)
	(defparameter minHN (nth 10 new-child))
	
	(if(= minHN 0)
		(progn 
			(format t "~%<<<<<<<<<<<<<<<<<<<< 8 PUZZLE PROBLEM SOLVED >>>>>>>>>>>>>>>>>>>>>>~%")
			(format t "<<<<<<<<<<<<<<<<<< Number of nodes expanded : ~a >>>>>>>>>>>>>>>>>>>>~%" counter)
			(format t "~%Order of traversal ~a ~%" (reverse closed-list))
			(FORMAT t "~%")
			(exit)
		)
		(progn
			(format t "~%Continuing to find the solution, current misplacement : ~a ~%~%" minHN)
			(find-pos1 new-child)
			(generate-states new-child Epos)
		)
	)

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; generate-states() ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Calls generate-position() to generate swap-list : list of all positions with which E should be swapped
;;; Calls swap-function by passing the swap-list to generate all the child-nodes
;;; Call splitList with the generate gList, which contains all the child nodes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun generate-states(puzzle pos)
	(format t "Current Puzzle : 9th Index is f(n) and 10th Index is h(n)~%")
	(format t "Current Puzzle : ~a ~%" puzzle)
	(generate-position puzzle pos)
	(setf glist '())
	(setf glist (swapfunc puzzle pos (car swap-list))) 
	(splitList glist)
)


(find-pos) ;; Find the current position of E
(misplaced-tiles) ;; Find the current number of tiles misplaced -> h(n)

;;; Generate a serialized list from the input list thatw as unserialized
(defvar mergedList (append (car initialPuzzle) (append (cadr initialPuzzle) (caddr initialPuzzle))))



;;;;;;;;;;;;;;;; Checking feasibility of the PUZZLE ;;;;;;;;;;;;;;;;;
;;; If the number of inversions is even, then the puzzle is feasible
;;; If the number of inversions is odd, then the puzzle is infeasible
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar inversions 0)
(defvar yloop (cdr mergedList))

(loop for x in mergedList
	do (
			loop for y in yloop
			do (if(and(and (not(eq x 'E)) (not(eq y 'E)))(> x y))					
					(progn
						;;(format t "~a ~a ~%" x y)
						(setf inversions (+ inversions 1))	
			   		)
			   )
		)
		(setf yloop (cdr yloop))
		
)
(if(eq (mod inversions 2) 1)
	(progn
		(format t "~%<<<<<<< INFEASIBLE PUZZLE >>>>>>>>> ~%")
		(format t "Total Inversions = ~a~%" inversions)
		(exit)
	)
)


(push mergedList closed-list) ;; push the initial list to the closed-list
(setq mergedList (append mergedList (list nMisplaced))) ;; adding f(n) to the serialized list
(setq mergedList (append mergedList (list nMisplaced))) ;; adding h(n) to the serialised list
(misplaced-tiles1 mergedList)

;;; Check if the first state is the goal state
(if(= nMisplaced 0)
	(progn
		(print "The Puzzled is in Solved State")
		(exit)
	)
)

;;; Calling genearte-states() by passing the parent-node and the position-of-E
(generate-states mergedList Epos)







