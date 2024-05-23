import 'package:flutter/material.dart';
import '../theme/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              SizedBox(width: 10.0), // İki konteyner arasında boşluk bırakmak için
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
          )
        ],
      ),
    ); // Scaffold
  }
}
