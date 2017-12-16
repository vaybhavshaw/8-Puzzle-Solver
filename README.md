# 8-Puzzle-Solver
Artificially Intelligent Code to solve the 8 puzzle problem using LISP

## Problem Definition
An 8 puzzle is a simple game consisting of a 3 x 3 grid (containing 9 squares). One of the squares is empty. 
The object is to move to squares around into different positions and having the numbers displayed in the "goal state". 
The image to the left can be thought of as an unsolved initial state of the "3 x 3" 8 puzzle.

## Approach Taken
1. Take the input of the puzzle from the user
2. Check whether the input is a list or not
3. Check whether the puzzle is valid or not by checking the number of inversions
4. Define function find-pos() to find the current position of the Empty Tile
5. Define function misplaced-tiles() to find the total number of misplaced tiles, i.e; h(n)
6. Define function generate-position() to find the list of positions with which E can be swapped
7. Define function swap-func() to generate a list of child nodes by swapping the position of E
with the elements in the list returned by generate-position() function
8. Define function splitList() which does the following :- a. Find the f(n), g(n), h(n) values of the child nodes
b. Store untraversed child nodes with their h(n) and f(n) values in the open-list c. Sort the open-list in ascending-order depending on the lowest value of f(n) d. Find the f(n) value of the first element of sorted open-list
e. Define a sort-list which stores all elements with the smallest f(n) value
f. Sort the list sort-list on the smallest h(n) value to find most optimal child state
g. If the h(n) value of the selected child node = 0, goal state found, print the number
of nodes expanded and the order of traversal
h. If the h(n) value of the selected child node != 0, goal state not found, call splitList() again by passing the selected child node.
9. Define function generate-states() that does the following :-
a. Calls the function generate-position() and receives the swap values from splitList() b. Calls function splitList() and passes the swap-list
10. Call the function generate-state()

## Output 
![index](./output.png)
