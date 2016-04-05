#Chess!
The classic game of strategy and deft maneuvers. Improve your skills with this chess engine which can be played on your computer's command line at any time. Just fire up your Terminal and start playing.
![Alt text](https://github.com/sco-bo/chess/blob/master/public/Intro.png?raw=true)

##Built based on OO principles
This game was built in Ruby with OO (Object Oriented) principles in mind. 

* **Pieces** were built as "dumb" as possible. They ensure separation of concerns by leaving the state of the board to the **Board**.

* **Board** is made up of **Square** objects which have Pieces on them (or not). The Board has a general idea of what moves are available/allowed and what moves are not, based on the state of the board. It also keeps a **History** of past moves.

* **Player** knows about his/her own pieces and he/she is the one to know what a piece can and cannot do.

* **Game** controls the flow of the game (whose turn it is, what move that player wants to make, whether or not that move is a valid choice, etc.) Game also checks for and responds appropriately to all possible chess scenarios: 
    * [check](https://en.wikipedia.org/wiki/Check_(chess))
    * [checkmate](https://en.wikipedia.org/wiki/Checkmate)
    * [castling](https://en.wikipedia.org/wiki/Castling)
    * [en passant](https://en.wikipedia.org/wiki/En_passant)
    * [pawn promotion](https://en.wikipedia.org/wiki/Promotion_(chess))
    * [stalemate](https://en.wikipedia.org/wiki/Stalemate)
    * [insufficient material](https://en.wikipedia.org/wiki/Draw_(chess))
    * [three-fold repetition](https://en.wikipedia.org/wiki/Threefold_repetition)
    * [fifty-move rule](https://en.wikipedia.org/wiki/Fifty-move_rule)

![Alt text](https://github.com/sco-bo/chess/blob/master/public/Fools_Mate.png?raw=true)
     
##Saving and Loading Games
A game can be saved using YAML and saved games can be loaded from the YAML file.
![Alt text](https://github.com/sco-bo/chess/blob/master/public/YAML_Save.png?raw=true)