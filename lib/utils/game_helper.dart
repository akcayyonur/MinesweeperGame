import 'dart:math';
import 'package:flutter/material.dart';
import 'package:miinesweeper/ui/screens/main_screen.dart';

class MinesweeperGame extends StatefulWidget {
  @override
  _MinesweeperGameState createState() => _MinesweeperGameState();
}

class _MinesweeperGameState extends State<MinesweeperGame> {
  MinesweeperGameHelper? _currentGame;

  //Function to start the game
  void _startGame(int rows, int columns, int totalMines) {
    setState(() {
      _currentGame = MinesweeperGameHelper(
        rows: rows,
        columns: columns,
        totalMines: totalMines,
      );
    });
    //When clicked, navigate to the main screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(gameHelper: _currentGame!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minesweeper', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/giphy.gif',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: _currentGame == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //button to start an beginner game
                ElevatedButton(
                  onPressed: () {
                    _startGame(6, 6, 5); // Beginner level
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)
                  ),
                  child: Text('Beginner', style: TextStyle(color: Colors.white),
                  ),
                ),
                //button to start an intermediate game
                ElevatedButton(
                  onPressed: () {
                    _startGame(8, 8, 7); // Intermediate level
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)
                  ),
                  child: Text('Intermediate', style: TextStyle(color: Colors.white),
                  ),
                ),
                //button to start an expert game
                ElevatedButton(
                  onPressed: () {
                    _startGame(10, 10, 10); // Expert level
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)
                  ),
                  child: Text('Expert', style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _currentGame!.columns,
              ),
              itemBuilder: (context, index) {
                final int row = index ~/ _currentGame!.columns;
                final int col = index % _currentGame!.columns;
                final Cell cell = _currentGame!.map[row][col];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _currentGame!.getClickedCell(cell);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(2),
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        cell.reveal ? cell.content.toString() : '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: _currentGame!.rows * _currentGame!.columns,
            ),
          ),
        ],
      ),
    );
  }
}

class MinesweeperGameHelper {
  int rows;
  int columns;
  int totalMines;
  int remainingFlags;
  bool gameOver = false;
  bool gameWon = false;
  List<Cell> gameMap = [];
  List<List<Cell>> map = [];

  //constructor that initializes the game map and place minea
  MinesweeperGameHelper({
    required this.rows,
    required this.columns,
    required this.totalMines,
  }) : remainingFlags = totalMines {
    map = List.generate(
        rows, (x) => List.generate(columns, (y) => Cell(x, y, "", false, false)));
    generateMap();
  }

  //generates the game map and places mines
  void generateMap() {
    placeMines(totalMines);
    gameMap = List<Cell>.generate(
        rows * columns,
            (index) {
          int row = index ~/ columns;
          int col = index % columns;
          return map[row][col];
        });
  }

  //resets the game
  void resetGame() {
    map = List.generate(
        rows, (x) => List.generate(columns, (y) => Cell(x, y, "", false, false)));
    gameMap.clear();
    generateMap();
    gameOver = false;
    gameWon = false;
    remainingFlags = totalMines;
  }

  //places mines randomly on the map
  void placeMines(int minesNumber) {
    Random random = Random();
    for (int i = 0; i < minesNumber; i++) {
      int mineRow = random.nextInt(rows);
      int mineCol = random.nextInt(columns);
      while (map[mineRow][mineCol].content == "X") {
        mineRow = random.nextInt(rows);
        mineCol = random.nextInt(columns);
      }
      map[mineRow][mineCol] = Cell(mineRow, mineCol, "X", false, false);
    }
  }

  //show all mines on the map
  void showMines() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        if (map[i][j].content == "X") {
          map[i][j].reveal = true;
        }
      }
    }
  }

  //handles the logic when a cell is clicked
  void getClickedCell(Cell cell) {
    if (cell.isFlagged) return;

    if (cell.content == "X") {
      showMines();
      gameOver = true;
    } else {
      int mineCount = 0;
      int cellRow = cell.row;
      int cellCol = cell.col;

      for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, rows - 1); i++) {
        for (int j = max(cellCol - 1, 0); j <= min(cellCol + 1, columns - 1); j++) {
          if (map[i][j].content == "X") {
            mineCount++;
          }
        }
      }

      cell.content = mineCount;
      cell.reveal = true;
      if (mineCount == 0) {
        for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, rows - 1); i++) {
          for (int j = max(cellCol - 1, 0); j <= min(cellCol + 1, columns - 1); j++) {
            if (!map[i][j].reveal && !map[i][j].isFlagged) {
              getClickedCell(map[i][j]);
            }
          }
        }
      }
    }
  }

  //toggles the flag status of a cell
  void toggleFlag(Cell cell) {
    if (cell.reveal) return;
    if (cell.isFlagged) {
      cell.isFlagged = false;
      remainingFlags++;
    } else if (remainingFlags > 0) {
      cell.isFlagged = true;
      remainingFlags--;
    }
    checkWinCondition();
  }

  //checks if the player has won the game
  void checkWinCondition() {
    bool allMinesFlagged = true;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
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

  //cell instructor
  Cell(this.row, this.col, this.content, this.reveal, this.isFlagged);
}
