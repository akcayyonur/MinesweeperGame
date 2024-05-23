import 'dart:math';
import 'package:flutter/material.dart';
import 'package:miinesweeper/ui/screens/main_screen.dart';

class MinesweeperGame extends StatefulWidget {
  @override
  _MinesweeperGameState createState() => _MinesweeperGameState();
}

class _MinesweeperGameState extends State<MinesweeperGame> {
  MinesweeperGameHelper? _currentGame;

  void _startGame(int rows, int columns, int totalMines) {
    setState(() {
      _currentGame = MinesweeperGameHelper(
        rows: rows,
        columns: columns,
        totalMines: totalMines,
      );
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(gameHelper: _currentGame!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _currentGame == null
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              _startGame(8,8, 10); // Beginner level
            },
            child: Text('Beginner'),
          ),
          ElevatedButton(
            onPressed: () {
              _startGame(6, 6, 10); // Intermediate level
            },
            child: Text('Intermediate'),
          ),
          ElevatedButton(
            onPressed: () {
              _startGame(8, 8, 15); // Expert level
            },
            child: Text('Expert'),
          ),
        ],
      ),
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
            // Handle cell tap here
            // You can call the corresponding function from MinesweeperGameHelper
            // based on the tapped cell's position (row, col)
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
    );
  }
}

class MinesweeperGameHelper {
  int rows;
  int columns;
  int totalMines;
  bool gameOver = false;
  List<Cell> gameMap = [];
  List<List<Cell>> map = [];

  MinesweeperGameHelper({
    required this.rows,
    required this.columns,
    required this.totalMines,
  }) {
    map = List.generate(
        rows, (x) => List.generate(columns, (y) => Cell(x, y, "", false)));
    generateMap();
  }

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


  void resetGame() {
    map = List.generate(
        rows,
            (x) => List.generate(columns, (y) => Cell(x, y, "", false))
    );
    gameMap.clear(); // gameMap'i temizler
    generateMap(); // Yeni haritayı oluşturur
  }

  void placeMines(int minesNumber) {
    Random random = Random();
    for (int i = 0; i < minesNumber; i++) {
      int mineRow = random.nextInt(rows);
      int mineCol = random.nextInt(columns);
      map[mineRow][mineCol] = Cell(mineRow, mineCol, "X", false);
    }
  }

  void showMines() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        if (map[i][j].content == "X") {
          map[i][j].reveal = true;
        }
      }
    }
  }

  void getClickedCell(Cell cell) {
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
            if (map[i][j].content == "") {
              getClickedCell(map[i][j]);
            }
          }
        }
      }
    }
  }
}

class Cell {
  int row;
  int col;
  dynamic content;
  bool reveal = false;
  Cell(this.row, this.col, this.content, this.reveal);
}
