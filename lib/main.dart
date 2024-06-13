// import 'dart:developer';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/theme.dart';
import 'views/screens/home/home.dart';
import 'welcome.dart';

Future<void> main() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  //  FirebaseMessaging.instance.getToken().then((value) {
  //   log("$value");
  //  });
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences? prefs;

  String idUser = '';
  String name = '';
  String branch_id='';

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  Future<void> getUserID() async {
  

    prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = prefs!.getString('userID') ?? ''; // Use the default value ''
      name = prefs!.getString('name') ?? '';
      branch_id = prefs!.getString('branch_id') ?? '';
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: CustomTheme.myTheme,
      home: idUser.isEmpty
          ? WelcomeScreen()
          : HomeScreen(username: name, UserId: idUser,branch_id: branch_id,),
    );
  }
}



