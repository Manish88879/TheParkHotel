import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'homePage.dart'; // Assuming this is the page you want to navigate to if userId exists
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  runApp(MyApp(userId: userId));
  print('UserId -- $userId');
}

class MyApp extends StatelessWidget {
  final String? userId;

  const MyApp({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: userId != null ? HomePage() : MyLoginPage(title: 'Login Page'),
    );
  }
}
