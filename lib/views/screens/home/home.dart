import 'dart:developer';
// import 'package:abc/views/screens/pay_summary/pay_summary.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../API_connect/API_connect.dart';
import '../cash_report/cash_report.dart';
import '../dashboard/dashboard.dart';
import '../income_report/income_report.dart';
import '../admission/admissions_report.dart';
import '../login/login.dart';
import '../pay_summary/pay_summary.dart';
import '../visa_report/visa_report.dart';
import 'package:diagnostic/global_variable/globals.dart' as globals;

class HomeScreen extends StatefulWidget {
  final String username;
  final String UserId;
  final String branch_id;
  const HomeScreen(
      {Key? key,
      required this.username,
      required this.UserId,
      required this.branch_id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  final List<List<String>> tableData = [];
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];
  String idUser = '';
  String name = '';
  bool? islogin;
  SharedPreferences? prefs;
  bool isConnected = false;

  ////////////////////////////////////////////////////////////////
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('PermissionList') &&
        apiResponse['PermissionList'] is List) {
      List<dynamic> data = apiResponse['PermissionList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }
  /////////////////////////////////////////////////////////////////////

  Future<void> fetchUserData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = prefs!.getString('sd') ?? ''; // Use the default value ''
      name = prefs!.getString('name') ?? '';
    });

    try {
      if (idUser.isEmpty) {
        if (!isConnected) {
          responseData = await APIHelper.connect(
            context: context,
            endpoint: "/api/UserPermission",
            data: {"UserId": "${widget.UserId}"},
          );
          Map<String, dynamic> ApiResponse = responseData;
          listOfMaps = convertApiResponseToList(ApiResponse);
        }
        if (isConnected) {
          log("Failed to connect to the database");
          return;
        }

        tableData.clear();
        listOfMaps.forEach((row) {
          tableData.add([
            row['Samp_Disc'].toString(),
            row['admission'].toString(),
            row['income'].toString(),
            row['Dashboard'].toString(),
            row['ConfirmResults'].toString(),
            row['finalize'].toString()
          ]);
        });
        log("$tableData");
        globals.Samp_Disc = tableData[0][0];
        globals.ConfirmResults = tableData[0][4];
        globals.finalize = tableData[0][5];
        log(tableData[0][5]);
      }

      ////////////
      else if (idUser.isNotEmpty) {
        if (!isConnected) {
          responseData = await APIHelper.connect(
            context: context,
            endpoint: "/api/UserPermission",
            data: {"UserId": "$idUser"},
          );
          Map<String, dynamic> ApiResponse = responseData;
          listOfMaps = convertApiResponseToList(ApiResponse);
        }
        if (isConnected) {
          log("Failed to connect to the database");
          return;
        }

        tableData.clear();
        listOfMaps.forEach((row) {
          tableData.add([
            row['Samp_Disc'].toString(),
            row['admission'].toString(),
            row['income'].toString(),
            row['Dashboard'].toString(),
            row['ConfirmResults'].toString(),
            row['finalize'].toString()
          ]);
        });
        log("$tableData");

        globals.Samp_Disc = tableData[0][0];
        globals.ConfirmResults = tableData[0][4];
          globals.finalize = tableData[0][5];
        log(tableData[0][5]);
      }
    } catch (e) {
      // Handle the exception appropriately, such as logging the error
      // message or showing a user-friendly error message.
      log("$e");
    }
  }

  //////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    return isPortrait
        ? Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff1f63b6),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            MediaQuery.of(context).size.width / 7.0,
                          ),
                          bottomRight: Radius.circular(
                            MediaQuery.of(context).size.width / 7.0,
                          ))),
                  height: MediaQuery.of(context).size.height / 3.5,
                ),

                //////////
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 10.0,
                          margin: EdgeInsets.only(bottom: 40.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          50.0),
                                  child: CircleAvatar(
                                    radius: 32,
                                    child: Text(
                                      "${widget.username.substring(0, 1).toUpperCase()}",
                                      style: TextStyle(fontSize: 40.0),
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(255, 231, 170, 79),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 20.0,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          40.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.username}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                28.0,
                                        left:
                                            MediaQuery.of(context).size.width /
                                                2.4),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage()));
                                        },
                                        icon: Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                        ))),
                              ],
                            ),
                          ),
                        ),

                        ///////////////
                        Expanded(
                          child: GridView.builder(
                            primary: false,
                            itemCount: 6,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing:
                                  MediaQuery.of(context).size.height / 50.0,
                              crossAxisSpacing:
                                  MediaQuery.of(context).size.width / 40.0,
                            ),
                            itemBuilder: (context, index) {
                              Widget iconWidget;
                              String itemText;
                              Widget destinationScreen;

                              switch (index) {
                                case 0:
                                  iconWidget = FaIcon(
                                    FontAwesomeIcons.folderOpen,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = "Admission";
                                  destinationScreen = AdmissionReport(
                                    UserId: idUser,
                                    username: widget.username,
                                    branch_id: widget.branch_id,
                                  );

                                  break;

                                case 1:
                                  iconWidget = Icon(
                                    Icons.dashboard,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = "Dashboard";
                                  destinationScreen = DashboardScreen(
                                    user_id: widget.UserId,
                                  );

                                  break;

                                case 2:
                                  iconWidget = Icon(
                                    Icons.local_mall,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = 'Income Report';
                                  destinationScreen = IncomeReport(
                                    username: widget.username,
                                    branch_id: widget.branch_id,
                                    user_id: widget.UserId,
                                  ); // Change the destination screen here

                                  break;

                                case 3:
                                  iconWidget = Icon(
                                    Icons.attach_money,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = 'Cash Report';
                                  destinationScreen = CashReport(
                                    username: widget.username,
                                    branch_id: widget.branch_id,
                                    user_id: widget.UserId,
                                  ); // Change the destination screen here
                                  break;

                                case 4:
                                  iconWidget = FaIcon(
                                    FontAwesomeIcons.fileInvoiceDollar,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = 'VISA Report';
                                  destinationScreen = VisaReport(
                                    username: widget.username,
                                    branch_id: widget.branch_id,
                                    user_id: widget.UserId,
                                  ); // Change the destination screen here

                                  break;

                                case 5:
                                  iconWidget = ImageIcon(
                                    AssetImage("assets/icon-summary.png"),
                                    size: MediaQuery.of(context).size.width/7.0,
                                    color: Colors.white,
                                  );
                                  // Icon(Icons.notifications,
                                  //     size: MediaQuery.of(context).size.width /
                                  //         7.0,
                                  //     color: Colors.white);
                                  itemText = 'Payment Summary';
                                  destinationScreen = PaymentSummary(user_id: widget.UserId,branch_id: widget.branch_id,);
                                  break;

                                default:
                                  iconWidget = Icon(
                                    Icons.local_mall,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = 'Other Item';
                                  destinationScreen = VisaReport(
                                    username: widget.username,
                                    branch_id: widget.branch_id,
                                    user_id: widget.UserId,
                                  ); // Change the destination screen here
                              }

                              return InkWell(
                                onTap: () {
                                  if (index == 0 &&
                                      tableData.isNotEmpty &&
                                      tableData[0][1] == 'True') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => destinationScreen,
                                      ),
                                    );
                                  } else if (index == 1 &&
                                      tableData.isNotEmpty &&
                                      tableData[0][3] == 'True') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => destinationScreen,
                                      ),
                                    );
                                  } else if (index == 2 &&
                                      tableData.isNotEmpty &&
                                      tableData[0][2] == 'True') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => destinationScreen,
                                      ),
                                    );
                                  }
                                  if (index == 3 &&
                                      tableData.isNotEmpty &&
                                      tableData[0][2] == 'True') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => destinationScreen,
                                      ),
                                    );
                                  } else if (index == 4 &&
                                      tableData.isNotEmpty &&
                                      tableData[0][2] == 'True') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => destinationScreen,
                                      ),
                                    );
                                  }
                                  else if (index == 5) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            destinationScreen,
                                      ),
                                    );
                                  }
                                  else if (index == 0 &&
                                      tableData.isNotEmpty &&
                                      tableData[0][1] != 'True') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text(
                                            "There is no permission ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0),
                                          ),
                                          backgroundColor: Color(0xff1f63b6),
                                        );
                                      },
                                    );
                                  } else if (index == 1 &&
                                      tableData.isNotEmpty &&
                                      tableData[0][3] != 'True') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text(
                                            "There is no permission ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0),
                                          ),
                                          backgroundColor: Color(0xff1f63b6),
                                        );
                                      },
                                    );
                                  } else if (index == 2 &&
                                      tableData.isNotEmpty &&
                                      tableData[0][2] != 'True') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text(
                                            "There is no permission ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0),
                                          ),
                                          backgroundColor: Color(0xff1f63b6),
                                        );
                                      },
                                    );
                                  }
                                  if (index == 3 &&
                                      tableData.isNotEmpty &&
                                      tableData[0][2] != 'True') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text(
                                            "There is no permission ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0),
                                          ),
                                          backgroundColor: Color(0xff1f63b6),
                                        );
                                      },
                                    );
                                  } else if (index == 4 &&
                                      tableData.isNotEmpty &&
                                      tableData[0][2] != 'True') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text(
                                            "There is no permission ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0),
                                          ),
                                          backgroundColor: Color(0xff1f63b6),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2.1,
                                      width: MediaQuery.of(context).size.width /
                                          2.1,
                                      margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                80.0,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                80.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF173D7C),
                                            Color(0xFF0096DA),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6.0,
                                          ),
                                          padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80.0,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50.0,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4.0,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2.0,
                                          color: Color(0xFF1F63B6),
                                          child: Text(
                                            itemText,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///////////
                                    Positioned(
                                      left: MediaQuery.of(context).size.width /
                                          6.7,
                                      top: MediaQuery.of(context).size.width /
                                          9.0,
                                      child: iconWidget,
                                    ),

                                    ////////
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///////////////
              ],
            ),
          )

        ////////////////////////
        : Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff1f63b6),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            MediaQuery.of(context).size.width / 4.0,
                          ),
                          bottomRight: Radius.circular(
                            MediaQuery.of(context).size.width / 4.0,
                          ))),
                  height: MediaQuery.of(context).size.height / 2.0,
                ),

                //////////
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height / 20.0),
                    child: Column(
                      children: [
                        Container(
                          height: 64,
                          margin: EdgeInsets.only(bottom: 40.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width /
                                        20.0),
                                child: CircleAvatar(
                                  radius: 32,
                                  child: Text(
                                    "${widget.username.substring(0, 1).toUpperCase()}",
                                    style: TextStyle(fontSize: 40.0),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 231, 170, 79),
                                ),
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.username}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          28.0,
                                      left: MediaQuery.of(context).size.width /
                                          2.0),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage()));
                                      },
                                      icon: Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                      ))),
                            ],
                          ),
                        ),

                        ///////////
                        Expanded(
                          child: GridView.builder(
                            primary: false,
                            itemCount: 5,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing:
                                  MediaQuery.of(context).size.height / 80.0,
                              crossAxisSpacing:
                                  MediaQuery.of(context).size.width / 80.0,
                            ),
                            itemBuilder: (context, index) {
                              Widget iconWidget;
                              String itemText;
                              Widget destinationScreen;

                              switch (index) {
                                case 0:
                                  iconWidget = FaIcon(
                                    FontAwesomeIcons.folderOpen,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = "Admission";
                                  destinationScreen = AdmissionReport(
                                    UserId: idUser,
                                    username: widget.username,
                                    branch_id: widget.branch_id,
                                  );

                                  break;

                                case 1:
                                  iconWidget = Icon(
                                    Icons.dashboard,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = "Dashboard";
                                  destinationScreen = DashboardScreen(
                                    user_id: widget.UserId,
                                  );

                                  break;

                                case 2:
                                  iconWidget = Icon(
                                    Icons.local_mall,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = 'Income Report';
                                  destinationScreen = IncomeReport(
                                    username: widget.username,
                                    branch_id: widget.branch_id,
                                    user_id: widget.UserId,
                                  ); // Change the destination screen here

                                  break;

                                case 3:
                                  iconWidget = Icon(
                                    Icons.attach_money,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = 'Cash Report';
                                  destinationScreen = CashReport(
                                    username: widget.username,
                                    branch_id: widget.branch_id,
                                    user_id: widget.UserId,
                                  ); // Change the destination screen here
                                  break;

                                case 4:
                                  iconWidget = FaIcon(
                                    FontAwesomeIcons.fileInvoiceDollar,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = 'VISA Report';
                                  destinationScreen = VisaReport(
                                    username: widget.username,
                                    branch_id: widget.branch_id,
                                    user_id: widget.UserId,
                                  ); // Change the destination screen here

                                  break;

                                default:
                                  iconWidget = Icon(
                                    Icons.local_mall,
                                    size:
                                        MediaQuery.of(context).size.width / 7.0,
                                    color: Colors.white,
                                  );
                                  itemText = 'Other Item';
                                  destinationScreen = VisaReport(
                                    username: widget.username,
                                    branch_id: widget.branch_id,
                                    user_id: widget.UserId,
                                  ); // Change the destination screen here
                              }

                              return Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (index == 0 &&
                                          tableData.isNotEmpty &&
                                          tableData[0][1] == 'True') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                destinationScreen,
                                          ),
                                        );
                                      } else if (index == 1 &&
                                          tableData.isNotEmpty &&
                                          tableData[0][3] == 'True') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                destinationScreen,
                                          ),
                                        );
                                      } else if (index == 2 &&
                                          tableData.isNotEmpty &&
                                          tableData[0][2] == 'True') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                destinationScreen,
                                          ),
                                        );
                                      }
                                      if (index == 3 &&
                                          tableData.isNotEmpty &&
                                          tableData[0][2] == 'True') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                destinationScreen,
                                          ),
                                        );
                                      } else if (index == 4 &&
                                          tableData.isNotEmpty &&
                                          tableData[0][2] == 'True') {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                destinationScreen,
                                          ),
                                        );
                                      }
                                      // else if (index == 5 &&
                                      //     tableData.isNotEmpty &&
                                      //     tableData[0][1] == 'True' &&
                                      //     tableData[0][2] == 'True' &&
                                      //     tableData[0][3] == 'True') {
                                      //   Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           destinationScreen,
                                      //     ),
                                      //   );
                                      // }
                                      else if (index == 0 &&
                                          tableData.isNotEmpty &&
                                          tableData[0][1] != 'True') {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const AlertDialog(
                                              content: Text(
                                                "There is no permission ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                              ),
                                              backgroundColor:
                                                  Color(0xff1f63b6),
                                            );
                                          },
                                        );
                                      } else if (index == 1 &&
                                          tableData.isNotEmpty &&
                                          tableData[0][3] != 'True') {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const AlertDialog(
                                              content: Text(
                                                "There is no permission ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                              ),
                                              backgroundColor:
                                                  Color(0xff1f63b6),
                                            );
                                          },
                                        );
                                      } else if (index == 2 &&
                                          tableData.isNotEmpty &&
                                          tableData[0][2] != 'True') {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const AlertDialog(
                                              content: Text(
                                                "There is no permission ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                              ),
                                              backgroundColor:
                                                  Color(0xff1f63b6),
                                            );
                                          },
                                        );
                                      }
                                      if (index == 3 &&
                                          tableData.isNotEmpty &&
                                          tableData[0][2] != 'True') {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const AlertDialog(
                                              content: Text(
                                                "There is no permission ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                              ),
                                              backgroundColor:
                                                  Color(0xff1f63b6),
                                            );
                                          },
                                        );
                                      } else if (index == 4 &&
                                          tableData.isNotEmpty &&
                                          tableData[0][2] != 'True') {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const AlertDialog(
                                              content: Text(
                                                "There is no permission ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                              ),
                                              backgroundColor:
                                                  Color(0xff1f63b6),
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.8,
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                80.0,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                80.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF173D7C),
                                            Color(0xFF0096DA),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.2,
                                          ),
                                          padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80.0,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50.0,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4.0,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2.0,
                                          color: Color(0xFF1F63B6),
                                          child: Text(
                                            itemText,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  ////////
                                  Positioned(
                                    left:
                                        MediaQuery.of(context).size.width / 6.7,
                                    top: MediaQuery.of(context).size.width /
                                        15.0,
                                    child: iconWidget,
                                  ),

                                  /////////
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
