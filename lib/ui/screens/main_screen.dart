import 'dart:async';
import 'package:flutter/material.dart';
import 'package:miinesweeper/utils/game_helper.dart';
import '../theme/colors.dart';

class MainScreen extends StatefulWidget {
  final MinesweeperGameHelper gameHelper;

  const MainScreen({Key? key, required this.gameHelper}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MinesweeperGameHelper gameHelper;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    gameHelper = widget.gameHelper;
    gameHelper.generateMap();//generate game map
    _startStopwatch();//start the stopwatch when game starts
  }

  //function to start the stopwatch
  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  //function to stop the stopwatch
  void _stopStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  //function to format the time as minutes:seconds
  String _formattedTime() {
    final duration = _stopwatch.elapsed;
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  //function to check if the player has won the game
  void _checkWinCondition() {
    if (gameHelper.gameWon) {
      _stopStopwatch();
    }
  }

  @override
  void dispose() {
    _stopStopwatch();//stop the watch when the widget is disposed
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
        title: const Text("MineSweeper"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
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
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.flag,
                        color: Colors.white,
                        size: 34.0,
                      ),
                      Text(
                        "${gameHelper.remainingFlags}",
                        style: const TextStyle(
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
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.timer,
                        color: Colors.white,
                        size: 34.0,
                      ),
                      Text(
                        _formattedTime(),
                        style: const TextStyle(
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
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gameHelper.columns,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: gameHelper.gameMap.length,
              itemBuilder: (BuildContext ctx, index) {
                //determine the color of the cell based on its state
                Color cellColor = gameHelper.gameMap[index].reveal
                    ? AppColor.clickedCard
                    : AppColor.lightPrimaryColor;
                return GestureDetector(
                  //handle tap on cell
                  onTap: gameHelper.gameOver
                      ? null
                      : () {
                    setState(() {
                      gameHelper.getClickedCell(gameHelper.gameMap[index]);
                      if (gameHelper.gameMap[index].content == "X") {
                        gameHelper.gameOver = true;
                        _stopStopwatch();//stop the watch if the game is over
                      }
                      _checkWinCondition();//check if the game is over
                    });
                  },
                  //handle long press to toggle flag on a cell
                  onLongPress: gameHelper.gameOver
                      ? null
                      : () {
                    setState(() {
                      gameHelper.toggleFlag(gameHelper.gameMap[index]);
                      _checkWinCondition();//check if the game is won
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Center(
                      child: gameHelper.gameMap[index].isFlagged
                          ? Icon(
                        Icons.flag,
                        color: Colors.red,
                        size: 20.0,
                      )
                          : Text(
                        gameHelper.gameMap[index].reveal
                            ? "${gameHelper.gameMap[index].content}"
                            : "",
                        style: TextStyle(
                          color: gameHelper.gameMap[index].reveal
                              ? gameHelper.gameMap[index].content == "X"
                              ? Colors.red
                              : AppColor.letterColors[gameHelper.gameMap[index].content]
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
          //display game status
          Text(
            gameHelper.gameOver
                ? (gameHelper.gameWon ? "You Won!" : "You Lost")
                : "",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          //button to restart the game
          RawMaterialButton(
            onPressed: () {
              setState(() {
                gameHelper.resetGame();
                _stopwatch.reset();//reset the stopwatch
                _startStopwatch();//restart the stopwatch
              });
            },
            fillColor: AppColor.lightPrimaryColor,
            elevation: 0,
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 24.0),
            child: Text(
              "Try again",
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
