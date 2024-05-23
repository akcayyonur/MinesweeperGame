import 'dart:math';

class MinesweeperGame {
  // Setting the game variables
  static int row = 6;
  static int col = 6;
  static int cells = row * col;
  int totalMines = 10;
  int remainingFlags = 10;
  bool gameOver = false;
  bool gameWon = false;
  List<Cell> gameMap = [];
  static List<List<dynamic>> map = List.generate(
      row, (x) => List.generate(col, (y) => Cell(x, y, "", false, false)));

  // Generate map function
  void generateMap() {
    PlaceMines(totalMines);
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        gameMap.add(map[i][j]);
      }
    }
  }

  // Function to reset the Game
  void resetGame() {
    map = List.generate(
        row, (x) => List.generate(col, (y) => Cell(x, y, "", false, false)));
    gameMap.clear();
    generateMap();
    gameOver = false;
    gameWon = false;
    remainingFlags = totalMines;
  }

  // Function to place mines randomly
  static void PlaceMines(int minesNumber) {
    Random random = Random();
    for (int i = 0; i < minesNumber; i++) {
      int mineRow = random.nextInt(row);
      int mineCol = random.nextInt(col);
      map[mineRow][mineCol] = Cell(mineRow, mineCol, "X", false, false);
    }
  }

  // Function to show all hidden mines if we lose
  void showMines() {
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (map[i][j].content == "X") {
          map[i][j].reveal = true;
        }
      }
    }
  }

  // Function to get what action to do when we click a cell
  void getClickedCell(Cell cell) {
    if (cell.isFlagged) return;  // If the cell is flagged, do nothing

    // To check if we clicked a mine
    if (cell.content == "X") {
      showMines();
      gameOver = true;
    } else {
      // To calculate the number to display near mines
      int mineCount = 0;
      int cellRow = cell.row;
      int cellCol = cell.col;

      for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, row - 1); i++) {
        for (int j = max(cellCol - 1, 0); j <= min(cellCol + 1, row - 1); j++) {
          if (map[i][j].content == "X") {
            mineCount++;
          }
        }
      }

      cell.content = mineCount;
      cell.reveal = true;
      if (mineCount == 0) {
        // Reveal all the adjacent cells until we get a number
        for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, row - 1); i++) {
          for (int j = max(cellCol - 1, 0); j <= min(cellCol + 1, row - 1); j++) {
            if (map[i][j].content == "") {
              // Recursive call to the function
              getClickedCell(map[i][j]);
            }
          }
        }
      }
    }
  }

  // Function to toggle flag on a cell
  void toggleFlag(Cell cell) {
    if (cell.reveal) return; // If the cell is already revealed, do nothing
    if (cell.isFlagged) {
      cell.isFlagged = false;
      remainingFlags++;
    } else if (remainingFlags > 0) {
      cell.isFlagged = true;
      remainingFlags--;
    }
    checkWinCondition();
  }

  // Function to check if the player has won the game
  void checkWinCondition() {
    bool allMinesFlagged = true;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (map[i][j].content == "X" && !map[i][j].isFlagged) {
          allMinesFlagged = false;
          break;
        }
      }
    }
    if (allMinesFlagged) {
      gameWon = true;
      gameOver = true;
    }
  }
}

class Cell {
  int row;
  int col;
  dynamic content;
  bool reveal = false;
  bool isFlagged = false;
  Cell(this.row, this.col, this.content, this.reveal, this.isFlagged);
}

