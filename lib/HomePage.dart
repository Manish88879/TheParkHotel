import 'package:flutter/material.dart';
import 'package:hotel_project/addCard.dart';
import 'package:hotel_project/addMoney.dart';
import 'package:hotel_project/checkBalance.dart';
import 'package:hotel_project/deleteCard.dart';
import 'package:hotel_project/loginPage.dart';
import 'package:hotel_project/makePayment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/hotelBackground.png', // Replace 'assets/background_image.jpg' with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.grey.withOpacity(0.3),
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.sizeOf(context).height * 0.1,
                horizontal: MediaQuery.sizeOf(context).width * 0.11),
            // color: , // Set background color here
            child: Card(
              color: Color.fromRGBO(255, 255, 255, 0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.sizeOf(context).width * 0.015,
                        horizontal: MediaQuery.sizeOf(context).height * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.sizeOf(context).height * 0.02),
                          child: Image.asset('assets/hotelLogo.png',
                              height: MediaQuery.sizeOf(context).height * 0.1),
                        ),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "Home",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                )),
                            Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "How it works ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                )),
                            Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "Features",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                )),
                            Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "FAQ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                )),
                            Container(
                                margin: EdgeInsets.all(14),
                                child: Text(
                                  "Get Started",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    child: const Text(
                      "POS for Hotels",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    child: Text(
                      "POS for Hotels",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        width: MediaQuery.sizeOf(context).width * 0.15,
                        child: Card(
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        width: MediaQuery.sizeOf(context).width * 0.15,
                        child: Card(
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        width: MediaQuery.sizeOf(context).width * 0.15,
                        child: Card(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
