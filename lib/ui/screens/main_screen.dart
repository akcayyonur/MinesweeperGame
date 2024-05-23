import 'dart:async';
import 'package:flutter/material.dart';
import 'package:miinesweeper/utils/game_helper.dart';
import '../theme/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MinesweeperGame game = MinesweeperGame();
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    game.generateMap();
    _startStopwatch();
  }

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  String _formattedTime() {
    final duration = _stopwatch.elapsed;
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _checkWinCondition() {
    if (game.gameWon) {
      _stopStopwatch();
    }
  }

  @override
  void dispose() {
    _stopStopwatch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text("MineSweeper"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.flag,
                        color: AppColor.accentColor,
                        size: 34.0,
                      ),
                      Text(
                        "${game.remainingFlags}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.timer,
                        color: AppColor.accentColor,
                        size: 34.0,
                      ),
                      Text(
                        _formattedTime(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 500.0,
            padding: EdgeInsets.all(20.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MinesweeperGame.row,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: MinesweeperGame.cells,
              itemBuilder: (BuildContext ctx, index) {
                Color cellColor = game.gameMap[index].reveal
                    ? AppColor.clickedCard
                    : AppColor.lightPrimaryColor;
                return GestureDetector(
                  onTap: game.gameOver
                      ? null
                      : () {
                    setState(() {
                      game.getClickedCell(game.gameMap[index]);
                      if (game.gameMap[index].content == "X") {
                        game.gameOver = true;
                        _stopStopwatch();
                      }
                      _checkWinCondition();
                    });
                  },
                  onLongPress: game.gameOver
                      ? null
                      : () {
                    setState(() {
                      game.toggleFlag(game.gameMap[index]);
                      _checkWinCondition();
                    });
                  },
                  onSecondaryTap: game.gameOver
                      ? null
                      : () {
                    setState(() {
                      game.toggleFlag(game.gameMap[index]);
                      _checkWinCondition();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Center(
                      child: game.gameMap[index].isFlagged
                          ? Icon(
                        Icons.flag,
                        color: Colors.red,
                      )
                          : Text(
                        game.gameMap[index].reveal
                            ? "${game.gameMap[index].content}"
                            : "",
                        style: TextStyle(
                          color: game.gameMap[index].reveal
                              ? game.gameMap[index].content == "X"
                              ? Colors.red
                              : AppColor.letterColors[
                          game.gameMap[index].content]
                              : Colors.transparent,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            game.gameOver
                ? (game.gameWon ? "Kazandınız!" : "Kaybettiniz")
                : "",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          RawMaterialButton(
            onPressed: () {
              setState(() {
                game.resetGame();
                _stopwatch.reset();
                _startStopwatch();
              });
            },
            fillColor: AppColor.lightPrimaryColor,
            elevation: 0,
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 24.0),
            child: Text(
              "Tekrar Deneyin",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
