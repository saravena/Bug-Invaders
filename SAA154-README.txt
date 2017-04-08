Name:		Sabrina A Aravena  |  SAA154@pitt.edu
Class: 		CS 447  |  Childers MW 3 - 4:15
Recitation:	M 12 - 12:50
Project: 	No.1  |  Space Invaders
Due: 		March 18, 2016

								README-Bugs
Implementation:
I implemented this program using an 'array' type memory buffer. Each element within the 'array' would hold two bytes. One byte was assigned as the X coordinate and the other was assigned as the Y coordinate. I had three types of buffers, one for bug coordinates, phaser coordinates, and wave coordinates (when a bug was hit). I had multiple word sized variabes that held information for those specific coordinates as well. Each time a new coordinate was created it would immediately be stored into an element within it's desired buffer. I would constantly update the pointer(offset) so the coordinates could be stored within their own element. 

The code written for the shooting phaser is very similiar to what have been written for both the wave and the bug fall. Each time interval, the current coordinates would turn off and the new updated ones would turn on depending on the action. For example, each time interval the phaser's Y coordinate would decrement by one until Y was less than zero. The Y coordinate for the bugs falling would increment by one each time interval until the updated Y coordinate equaled 63 (bug-shooters row). Pseudo code is provided to show the logic I would have written for both the wave and the bug fall.The bug fall was timed to run every 600ms, whereas the phaser and the wave would have ran every 100ms. 

Each time the phaser was shot, a counter stored within an 's' register would increment it's value by 1 every time the user pressed the up button. Another counter was set for when the coordinate of the phaser matched with one of a bug. The counter would increment by 1 each time a bug was hit. The same counter would update if the wave of a bug hit also hit another bug. Pseudo code is displayed within the program to show the logic of a bug hit for both the wave and direct hit from the phaser. 

In order to key poll I set up something similiar to that of a boolean function. I determined if there was key press by either returning a 1 (key press) or 0 (no key press). If a key press occured, I matched the button pressed to the character equivalent to that on the keyboard. Following I jumped to the specific function in order to display the action the user wanted. The center 'b' button intializes all counters and the position of the bug shooter and starts the system time.  The down button ('S' equivalent) ends the game and displays the output message and score of the game as well. After 2 mintues the game ends and jumps to the end_game function to display the same results. The left and right buttons moves the player and updates their postion as well as wrap around to the other side if they reach the edge. The stack trace was used heavily in order to save the current postions of the player (bug-shooter).


Comments:
- This program was very difficult for me and I could not complete all of it. That being said, for the stuff I didn't complete, I added various comments throughout the program with pseudo code and explanations (maybe for partial credit if possible)
- The phaser functions for the most part that you can shoot multiple times. However, when the phaser moves off the screen, MIPS throws an External Interruption error and crashes. I did not know how to fix that problem.
- I managed to set up four bugs to show up randomly in the top row when the game initially starts, but they do not move. I mentioned multiple times that I would have approached this similiary to that of the movement of the phaser and call a new set of bugs to appear within each time interval. 
- The argument made to check if the time passed 2 minutes did not work. I commented out those specific lines of code because it malfunctioned my program.
- Because the bugs do not move, I set up some lines of code for it to run every 600 ms, but keeping that code uncommented would've made my program not compile. Also, I could not physically increment my bugs shot counter (it displays 0 in the output). I do have pseudo code where I would count and how I would appoach the situation as well
- The wave and cascade do not work either. There is no physical code provided however, there is pseudo code with how I would have approached it logically.



