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

  @override
  void initState() {import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    gameHelper = widget.gameHelper;
    gameHelper.generateMap();
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.flag,
                        color: Colors.blue,
                        size: 34.0,
                      ),
                      Text(
                        "10",
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.timer,
                        color: Colors.blue,
                        size: 34.0,
                      ),
                      Text(
                        "10:32",
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: gameHelper.gameMap.length,
              itemBuilder: (BuildContext ctx, index) {
                Color cellColor = gameHelper.gameMap[index].reveal
                    ? AppColor.clickedCard
                    : AppColor.lightPrimaryColor;
                return GestureDetector(
                  onTap: gameHelper.gameOver
                      ? null
                      : () {
                    setState(() {
                      gameHelper.getClickedCell(gameHelper.gameMap[index]);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Center(
                      child: Text(
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
          Text(
            gameHelper.gameOver ? "Kaybettiniz" : "",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
            ),
          ),
          SizedBox(height: 20.0),
          RawMaterialButton(
            onPressed: () {
              setState(() {
                gameHelper.resetGame();
              });
            },
            fillColor: AppColor.lightPrimaryColor,
            elevation: 0,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 24.0),
            child: const Text(
              "Tekrar Deneyin",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}


    // TODO: implement initState
    super.initState();
    game.generateMap();
  }

  @override
  Widget build(BuildContext context) {
//let's store the colors in a seperate file
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text("MineSweeper"),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.settings))
          ]), // AppBar
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
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
                          "10",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(width: 10.0),
              // İki konteyner arasında boşluk bırakmak için
              Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
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
                          "10:32",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )),
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
                            });
                          },
                    child: Container(
                      decoration: BoxDecoration(
                          color: cellColor,
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Center(
                        child: Text(
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
                }),
          ),
          Text(
            game.gameOver ? "Kaybettiniz" : "",
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
                game.gameOver = false;
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
            height:20.0,
          ),
        ],
      ),
    ); // Scaffold
  }
}
