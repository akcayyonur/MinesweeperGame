//let's create the game helper class
import 'dart:math';
class MinesweeperGame {
// setting the game variables
  static int row = 6;
  static int col = 6;
  static int cells = row * col;
  bool gameOver = false;
  List<Cell> gameMap = [];
  static List<List<dynamic>> map = List.generate(row, (x) => List.generate(col, (y) => Cell(x,y,"",false)));
}
// generate map funciton
void generateMap(){

}

//function to place mines randomly
void PlaceMines(int minesNumber) {
  Random random = Random();


}



class Cell {
  int row;
  int col;
  dynamic content;
  bool reveal = false;
  Cell(this.row, this.col, this.content, this.reveal);
}