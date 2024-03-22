import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_project/makePayment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;

class AddMoney extends StatefulWidget {
  // const AddMoney({Key? key, required this.title});

  // final String title;

  @override
  State<AddMoney> createState() => _AddMoney();
}

class _AddMoney extends State<AddMoney> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  String? userId;

  @override
  void initState() {
    super.initState();
    _getUserIdFromSharedPreferences();
  }

  void _getUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  void addMoney() async {
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
      print('ID $userId');
      setState(() {
        isLoading = true; // Set loading state to true when request starts
      });
      var url =
          'https://phylopos.in/Theparkhotel/posAPI/addCardBalance.php/?cardnumber=${_cardNumber.text}&amount=${_amount.text}&user_id=${userId}';

      try {
        var response = await http.post(Uri.parse(url));
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print('Response body: ${response.body}');
          print('Response code: ${decodedResponse['response_code']}');

          if (decodedResponse['response_code'] == 0) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('${decodedResponse['response_message']}'),
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
        title: Text('Add Money'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 250.0, vertical: 10.0),
        color: Colors.deepPurpleAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 50),
              child: Image.asset(
                'assets/hotel.jpg', // Replace 'your_image.png' with the image path
                height: 100, // Adjust height as needed
              ),
            ),
            SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Enter Card Number ',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              controller: _cardNumber,
              keyboardType: TextInputType.number,
              maxLength: 16,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Enter Phone number',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              maxLength: 10,
              keyboardType: TextInputType.number,
              controller: _phoneController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
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
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
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
              onPressed: addMoney,
              child: isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : Text(
                      'Confirm with OTP',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitLogin() {
    String username = _usernameController.text;

    // Perform your login authentication here
    // You can add your logic to authenticate the user
    // For example, you can use APIs or validate against a predefined list of users

    // Once authentication is successful, you can navigate to the next screen
  }
}
