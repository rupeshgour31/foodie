import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodie_bell/CheckOrderStatus/checkOrderStatus.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_bell/Login/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getValuesSF();
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    Timer(
      Duration(seconds: 3),
      () {
        status
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckOrderStatus(),
                ),
                (Route<dynamic> route) => false,
              )
            : Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (Route<dynamic> route) => false,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: width,
            height: height,
            color: Color(0xffE5E5E5),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: height * 0.4,
                    width: width * 0.8,
                    child: Image.asset(
                      'assets/images/Vector.png',
                      color: Color(0xffFA8B01),
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                    width: width * 0.2,
                    child: Image.asset(
                      'assets/images/Group 12592.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 110.0),
                    child: SizedBox(
                      height: height * 0.03,
                      width: width * 0.25,
                      child: Image.asset(
                        'assets/images/Foodie Bell.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          progressHUD,
        ],
      ),
    );
  }
}
