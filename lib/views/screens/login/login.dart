import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../API_connect/API_connect.dart';
import 'package:diagnostic/global_variable/globals.dart' as globals;
import '../home/home.dart';
// import 'package:api_app/views/screens/Sign%20up/Sign_up.dart';
// import 'package:api_app/views/screens/guest_home/guest_home.dart';
// import 'package:api_app/views/screens/app_home/app_home.dart';
// import 'package:intl_phone_field/country_picker_dialog.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ///////////////////////Varibales////////////////////////////////////
  String? message;
  String userId = '';
  String name = '';
  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();
  TextEditingController controller_branch = TextEditingController();
  String enteredUsername = '';
  String enteredPassword = '';
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];
  List<Map<String, dynamic>> listOfMaps2 = [];
  String branches = '';
  String? branch_id;
  bool isConnected = false;
  Map<String, dynamic> branchNameToBrSeqMap = {};
  FocusNode _focus = FocusNode();

  ////////////////////Functions////////////////////////////////////
  @override
  void dispose() {
    controller_password.dispose();
    controller_username.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focus.hasFocus == false) {
      loginUser();
      // FocusScope.of(context).requestFocus(branch_Focus);
      // // or
      // branch_Focus.requestFocus();
    }
  }

  // Future<void> saveTokenToDatabase(String token) async {
  //   await FirebaseFirestore.instance
  //       .collection('users_token')
  //       .doc('X5AQyP53BwKVQY1YTPh6')
  //       .update({
  //     'token': FieldValue.arrayUnion([token]),
  //   });
  // }

  // Future<void> setupToken() async {
  //   // Get the token each time the application loads
  //   String? token = await FirebaseMessaging.instance.getToken();

  //   // Save the initial token to the database
  //   await saveTokenToDatabase(token!);
  // }

  //////////////////////////////////////////////////////

  // Assuming listOfMaps contains your API response

  void getBr_seq() {
    for (var data in listOfMaps) {
      final branchName = data['BranchName'] as String;
      final brSeq = data['Br_Seq'].toString();
      branchNameToBrSeqMap[branchName] = brSeq;
    }
  }

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('BranchList') &&
        apiResponse['BranchList'] is List) {
      List<dynamic> data = apiResponse['BranchList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }
  ///////////////////////////////////////////////////////

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList2(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('tests') && apiResponse['tests'] is List) {
      List<dynamic> data = apiResponse['tests'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }

  ////////////// Get Brnchs  ////////////////////
  Future<void> branchesOfUser(String id_user) async {
    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Branchs",
      data: {"UserID": "$id_user"},
    );
    Map<String, dynamic> ApiResponse = responseData;
    listOfMaps = convertApiResponseToList(ApiResponse);
    log("${listOfMaps}");
  }

  ///////////////////////////////////////////////

  // Login User Function
  Future<void> loginUser() async {
    enteredUsername = controller_username.text;
    String enteredPassword = controller_password.text;
    if (!isConnected) {
      responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/NEW",
        data: {
          "enteredUsername": "$enteredUsername",
          "enteredPassword": "$enteredPassword"
        },
      );
      Map<String, dynamic> ApiResponse = responseData;
      listOfMaps2 = convertApiResponseToList2(ApiResponse);
      log("$listOfMaps2");
    }
    if (isConnected) {
      log("Failed to connect to the API");
      return;
    }

    if (listOfMaps2.isNotEmpty) {
      userId = "${listOfMaps2[0]['id']}";
      globals.user_id = userId;
      name = enteredUsername;
      branchesOfUser(userId).then((value) {
        getBr_seq();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid username or password',
            style: TextStyle(color: Color.fromARGB(255, 182, 34, 55)),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  //////////////////////////// End Functions ///////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool value) async => false,
      child: Scaffold(
        backgroundColor: Color(0xff1f63b6),
        body: Container(
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              final Orientation orientation =
                  MediaQuery.of(context).orientation;
              final bool isPortarit = orientation == Orientation.portrait;
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  child: Container(
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xff1f63b6),
                            height: isPortarit
                                ? MediaQuery.of(context).size.height * 0.40
                                : MediaQuery.of(context).size.height * 0.50,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 40,
                                    child: Icon(
                                      Icons.person,
                                      color: Color(0xff1f63b6),
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //////////
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ///////////////// TextField Username //////////////////////////////
                                  TextField(
                                    controller: controller_username,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Color(0xff1f63b6),
                                      ),
                                      hintText: "Enter username",
                                      filled: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: const Color(0xff1f63b6),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: const Color(0xff1f63b6),
                                        ),
                                      ),
                                    ),
                                  ),

                                  ////////////
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              30.0),

                                  ///////////////////////// TextField Password ////////////////////////////////////
                                  TextField(
                                    focusNode: _focus,
                                    onSubmitted: (value) {
                                      loginUser();
                                    },
                                    controller: controller_password,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color(0xff1f63b6),
                                      ),
                                      hintText: "Enter Password",
                                      filled: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: const Color(0xff1f63b6),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: const Color(0xff1f63b6),
                                        ),
                                      ),
                                    ),
                                  ),

                                  //////////
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        30.0,
                                  ),

                                  /////

                                  ////////////////////// Select Branch /////////////////////////////////////////

                                  SearchField(
                                    suggestionStyle:
                                        TextStyle(color: Colors.white),
                                    suggestionsDecoration: SuggestionDecoration(
                                        color: Color(0xff1f63b6)),
                                    controller: controller_branch,
                                    suggestionDirection: SuggestionDirection.up,
                                    searchInputDecoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: const Color(0xff1f63b6),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: const Color(0xff1f63b6),
                                        ),
                                      ),
                                    ),
                                    itemHeight: 50,
                                    maxSuggestionsInViewPort: 6,
                                    hint: "Select Branch",
                                    suggestions: listOfMaps.map((data) {
                                      // Extract 'BranchName' from each map and convert it to a string
                                      final branchName =
                                          data['BranchName'] as String;
                                      return SearchFieldListItem<String>(
                                          branchName);
                                    }).toList(),
                                  ),

                                  //////////
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        10.0,
                                  ),

                                  /////

                                  Container(
                                    child: Center(
                                      child: Container(
                                        height: isPortarit
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15.0
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10.0,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              branches = controller_branch.text;
                                              branch_id = branchNameToBrSeqMap[
                                                  branches];
                                              log("$branch_id");
                                            });
                                            if (controller_username
                                                .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Please Enter Username',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 182, 34, 55)),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                ),
                                              );
                                            } else if (controller_password
                                                .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Please Enter Password',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 182, 34, 55)),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                ),
                                              );
                                            } else if (controller_branch
                                                .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Please Enter Branch',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 182, 34, 55)),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                ),
                                              );
                                            } else if (controller_username.text
                                                    .toUpperCase() !=
                                                listOfMaps2[0]['Name_user']
                                                    .toString()
                                                    .toUpperCase()) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Invalid Username',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 182, 34, 55)),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                ),
                                              );
                                            } else if (controller_password
                                                    .text.toUpperCase() !=
                                                listOfMaps2[0]['pwd']) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Invalid Password',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 182, 34, 55)),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                ),
                                              );
                                            } else if (branches.isEmpty ||
                                                controller_branch.text !=
                                                    branches) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Invalid Branch ',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 182, 34, 55),
                                                    ),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                ),
                                              );
                                            } else if (branch_id == null ||
                                                branch_id != branch_id) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Invalid Branch ',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 182, 34, 55),
                                                    ),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Login successful!',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff1f63b6)),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                ),
                                              );

                                              // Navigate to the home screen
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen(
                                                    username: enteredUsername,
                                                    UserId: userId,
                                                    branch_id: branch_id!,
                                                  ),
                                                ),
                                              );

                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs
                                                  .setString('userID', userId)
                                                  .then((value) {
                                                log("userId_valid");
                                              });
                                              await prefs.setString(
                                                  'name', name);
                                              prefs
                                                  .setBool('login', isConnected)
                                                  .then(
                                                (value) {
                                                  log("username_valid");
                                                },
                                              );

                                              await prefs
                                                  .setString(
                                                      'branch_id', branch_id!)
                                                  .then((value) {
                                                log("branch_id_valid");
                                              });

                                              //    .then((value) async {
                                              //   setState(() {
                                              //     setupToken();
                                              //   });
                                              // });
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Color(0xff1f63b6)),
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'LOGIN',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  /////////
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
