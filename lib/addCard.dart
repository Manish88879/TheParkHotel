import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// import 'package:hotel_project/addMoney.dart';
import 'HomePage.dart';
import 'addMoney.dart';
import 'package:http/http.dart' as http;

class AddCard extends StatefulWidget {
  // const RegisterUser({Key? key, required this.title});

  // final String title;

  @override
  State<AddCard> createState() => _AddCard();
}

class _AddCard extends State<AddCard> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _amount = TextEditingController();

  bool isLoading = false;

  void loginAPI() async {
    if (_usernameController.text == '' ||
        _cardNumber.text == '' ||
        _mobileNumber.text == '' ||
        _amount.text == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text('All field are mandatory'),
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
      var url =
          'https://phylopos.in/Theparkhotel/posAPI/register.php?cardnumber=${_cardNumber.text}&amount=${_amount.text}&name=${_usernameController.text}&phone=${_mobileNumber.text}';

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
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
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
        title: Text('Add Card'),
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
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Enter your name',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.purple, // Set border color here
                    width: 4.0, // Set border width here
                  ),
                ),
              ),
              controller: _usernameController,
            ),
            SizedBox(height: 20),
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
                labelText: 'Enter mobile number',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.purple, // Set border color here
                    width: 4.0, // Set border width here
                  ),
                ),
              ),
              controller: _mobileNumber,
              maxLength: 10,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Enter amount ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.purple, // Set border color here
                    width: 4.0, // Set border width here
                  ),
                ),
              ),
              controller: _amount,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            // SizedBox(height: 20),
            SizedBox(height: 40),
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
              onPressed: loginAPI,
              child: isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : Text(
                      'Add',
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
