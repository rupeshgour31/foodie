import 'package:flutter/material.dart';
import 'package:foodie_bell/CheckOrderStatus/checkOrderStatus.dart';
import 'package:foodie_bell/OrderDetails/orderDetailsPage.dart';
import 'package:foodie_bell/OrderHistory/orderHistory.dart';
import 'package:foodie_bell/SplashScreen/splashScreen.dart';
import 'package:foodie_bell/Success/successPage.dart';
import 'package:foodie_bell/orderPickup/orderPickup1.dart';
import 'package:foodie_bell/orderPickup/orderPickup2.dart';
import 'package:foodie_bell/orderPickup/orderPickup3.dart';
import 'package:foodie_bell/payAndDeliver/payAndDeliverPage.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodie Bell',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Color(0xffFA8B01),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/checkOrderStatus': (context) => CheckOrderStatus(),
        '/orderDetails': (context) => OrderDetails(),
        '/orderHistory': (context) => OrderHistory(),
        '/payAndDeliver': (context) => PayAndDeliver(),
        '/successPage': (context) => SuccessPage(),
        '/orderPickupOne': (context) => OrderPickupOne(),
        '/orderPickupTwo': (context) => OrderPickupTwo(),
        '/orderPickupThree': (context) => OrderPickupThree(),
      },
    );
  }
}
