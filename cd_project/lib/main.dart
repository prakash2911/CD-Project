import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cd_project/screen/inputScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main()
{
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Detail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        splash: Column(
          children: [
            ClipOval(
              child: Image(
                image: AssetImage("asset/icon.png"),
                fit: BoxFit.fill,
                height: 150,
                width: 150,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              "Detail",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffF5EFE6)),
            )
          ],
        ),
        // duration: 1500,
        backgroundColor: Color(0xff7895B2),
        splashIconSize: 250,
        centered: true,
        curve: Curves.fastOutSlowIn,
        nextScreen: MyHomePage(),
        splashTransition: SplashTransition.sizeTransition,
        animationDuration: Duration(milliseconds: 2000),
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return InputDetails() ;
  }
}
