import 'package:flutter/material.dart';
import 'views/screens/login/login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    // Use a Future.delayed to navigate after a delay
    Future.delayed(Duration(seconds: 4), () {
      if (!_isDisposed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                'assets/welcome.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
