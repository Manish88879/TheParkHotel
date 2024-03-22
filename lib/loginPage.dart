import 'dart:convert';
import 'package:hotel_project/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// import 'package:hotel_project/addMoney.dart';
import 'HomePage.dart';
import 'addMoney.dart';
import 'package:http/http.dart' as http;

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title});

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isHovered = false;

  bool isLoading = false;

  void loginAPI() async {
    if (_usernameController.text == '' || _passwordController.text == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
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
          'https://phylopos.in/Theparkhotel/posAPI/login.php?email=${_usernameController.text}&password=${_passwordController.text}';

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
            print('ID -- ${decodedResponse['data']['id']}');
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('userId', decodedResponse['data']['id']);
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
    final Size screen = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).highlightColor,
      //   title: Text(widget.title),
      // ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screen.width * 0.1, vertical: screen.width * 0.1),
        color: Colors.blueGrey,
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login to',
                            style: TextStyle(color: Colors.grey, fontSize: 30),
                          ),
                          Text(
                            ' The Park Hotel',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        'Manage your hotel Management from here',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: screen.height * 0.05),
                        width: screen.width * 0.26,
                        height: screen.height * 0.06,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.blueGrey, // Set border color here
                                width:
                                    screen.width * 0.1, // Set border width here
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: screen.height * 0.05),
                        width: screen.width * 0.26,
                        height: screen.height * 0.06,
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.blueGrey, // Set border color here
                                width:
                                    screen.width * 0.1, // Set border width here
                              ),
                            ),
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) {
                          setState(() {
                            isHovered = true;
                          });
                        },
                        onExit: (HomePage) {
                          setState(() {
                            isHovered = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: (() => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage())),
                              }),
                          child: Container(
                            width: screen.width * 0.264,
                            decoration: BoxDecoration(
                              color: isHovered ? Colors.white : Colors.blueGrey,
                              border: Border.all(
                                color: Colors
                                    .blueGrey, // Change border color on hover
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            margin: EdgeInsets.only(top: screen.height * 0.06),
                            alignment: Alignment.center,
                            height: screen.height * 0.05,
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: isHovered
                                      ? Colors.blueGrey
                                      : Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Right Side
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(13.0),
                  bottomRight: Radius.circular(15.0),
                ),
                child: Image.asset(
                  'assets/loginImage.jpg', // Replace with your image URL
                  height: screen.height * 1.1, // Adjust width as needed
                  width: screen.width * 0.45, // Adjust height as needed
                  fit: BoxFit.fill, // Adjust the fit as needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
