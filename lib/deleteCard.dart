import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;

class DeleteCard extends StatefulWidget {
  // const AddMoney({Key? key, required this.title});

  // final String title;

  @override
  State<DeleteCard> createState() => _DeleteCard();
}

class _DeleteCard extends State<DeleteCard> {
  final TextEditingController _cardNumber = TextEditingController();
  String balance = '0';

  bool isLoading = false;

  void deleteCard() async {
    if (_cardNumber.text == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text('Card number is mandatory'),
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
      setState(() {
        isLoading = true; // Set loading state to true when request starts
      });
      print('Card Number ${_cardNumber.text}');
      var url =
          'https://phylopos.in/Theparkhotel/posAPI/deletecard.php?cardnumber=${_cardNumber.text}';

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
                  title: Text('Message'),
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
          } else if (decodedResponse['response_code'] == 1) {
            setState(() {
              balance = decodedResponse['cardbalance'];
            });
            print('Success dialogue box should show');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text('Done'),
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
        title: Text('Delete Card'),
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
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Enter Card Number',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              maxLength: 16,

              controller: _cardNumber,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Filter only
            ),
            SizedBox(height: 30),
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
              onPressed: deleteCard,
              child: isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            SizedBox(height: 50),
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
  }
}
