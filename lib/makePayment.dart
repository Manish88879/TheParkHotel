import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_project/checkBalance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;

class MakePayment extends StatefulWidget {
  // const AddMoney({Key? key, required this.title});

  // final String title;

  @override
  State<MakePayment> createState() => _MakePayment();
}

class _MakePayment extends State<MakePayment> {
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _amount = TextEditingController();

  String extractCardNumber(String input) {
    return input.replaceAll(
        RegExp(r'[^0-9]'), ''); // Extract numeric characters
  }

  String? userId;

  @override
  void initState() {
    super.initState();
    // Set the initial value of the _cardNumber controller here
    _cardNumber.text = extractCardNumber(_cardNumber.text);
    _getUserIdFromSharedPreferences();
  }

  void _getUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  bool isLoading = false;

  void MakePayment() async {
    if (_amount.text == '' || _cardNumber.text == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Errors'),
            content: Text('All fields are required.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print('ID - $userId');
      setState(() {
        isLoading = true; // Set loading state to true when request starts
      });
      String cardNumber = extractCardNumber(_cardNumber.text);
      String cardNumberToBeUsed =
          cardNumber.substring(max(0, cardNumber.length - 16));

      print('cardNumber ${cardNumberToBeUsed}');

      var url =
          'https://phylopos.in/Theparkhotel/posAPI/useCardBalance.php/?cardnumber=${cardNumber}&amount=${_amount.text}&user_id=$userId';

      try {
        var response = await http.post(Uri.parse(url));
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print(response.body);
          print('Requiest --- ${response.request}');
          if (decodedResponse['response_code'] == 0) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(' ${decodedResponse['response_message']}'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else if (decodedResponse['response_code'] == 1) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text('${decodedResponse['response_message']}'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                );
              },
            );
            // Optionally, you can also navigate back to the previous screen
            // Navigator.of(context).pop();
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(' ${decodedResponse['response_message']}'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            Navigator.of(context).pop();
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(
                    'Failed to fetch data. Status Code: ${response.reasonPhrase}'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          print('Else ---- ${response.reasonPhrase}');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('${e}'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } finally {
        setState(() {
          isLoading =
              false; // Set loading state to false when request completes
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).highlightColor,
        title: Text('Make Payment'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 250.0, vertical: 10.0),
        color: Colors.deepPurpleAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 50),
                child: Image.network(
                    'https://phylopos.in/Theparkhotel/app2/assets/assets/hotel.jpg',
                    height: 100)),
            SizedBox(height: 20),
            TextField(
              maxLength: 16,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Enter Card Number',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              controller: _cardNumber,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Filter only
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amount,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Enter Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black87),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5.0), // Adjust the border radius as needed
                  ),
                ), // Change the color to your desired color
              ),
              onPressed: MakePayment,
              child: isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitLogin() {
    // Perform your login authentication here
    // You can add your logic to authenticate the user
    // For example, you can use APIs or validate against a predefined list of users

    // Once authentication is successful, you can navigate to the next screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => CheckBalance()),
    // );
  }
}
