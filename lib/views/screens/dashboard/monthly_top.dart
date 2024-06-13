import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../../API_connect/API_connect.dart';

class MonthlyTop extends StatefulWidget {
  final String user_id;
  const MonthlyTop({super.key, required this.user_id});

  @override
  State<MonthlyTop> createState() => _MonthlyTopState();
}

class _MonthlyTopState extends State<MonthlyTop> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 1), () {
      TodayRequestedTest();
    });
    super.initState();
  }

  TextEditingController controllerMonth = TextEditingController();
  TextEditingController controllerYear = TextEditingController();
  TextEditingController controllerTop = TextEditingController();
  List<List<String>> chartData = [];
  List<BarCahrtData> data = [];
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;

  @override
  void dispose() {
    controllerMonth.dispose();
    controllerTop.dispose();
    controllerYear.dispose();
    super.dispose();
  }

  String stripMargin(var s) {
    String z = "";
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(s.toString());

    for (var i = 0; i < lines.length; i++) {
      z += lines[i].trim();
    }

    return z;
  }

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('TopLists') &&
        apiResponse['TopLists'] is List) {
      List<dynamic> data = apiResponse['TopLists'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }




  Future<void> TodayReferral() async {
    setState(() {
      isChecked1=true;
    });
    final formatterYear = DateFormat('yyy');
    final formatterMonth = DateFormat('MM');
    final nowYear = formatterYear.format(DateTime.now());
    final nowMonth = formatterMonth.format(DateTime.now());

    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Top_Referral",
      data: {"Year": "$nowYear", "Month": "$nowMonth", "Top": "10","UserID": "${widget.user_id}"},
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);
    setState(() {
      chartData.clear();
      listOfMaps.asMap().forEach((index, row) {
        chartData.add([
          (index + 1).toString(),
          row['cnt'].toString(),
          row['topCode'].toString(),
          row['topName'].toString(),
        ]);
      });
    });
    log("$chartData");
    List<BarCahrtData> newData = [];
    for (var row in chartData) {
      newData.add(BarCahrtData(row[3], double.parse(row[1])));
    }

    // Update the state to trigger a rebuild with the new data
    setState(() {
      data = newData;
    });
  }


Future<void> TodayDoctors() async {
    setState(() {
      isChecked1=true;
    });
    final formatterYear = DateFormat('yyy');
    final formatterMonth = DateFormat('MM');
    final nowYear = formatterYear.format(DateTime.now());
    final nowMonth = formatterMonth.format(DateTime.now());

    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Top_Doctors",
      data: {"Year": "$nowYear", "Month": "$nowMonth", "Top": "10","UserID": "${widget.user_id}"},
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);
    setState(() {
      chartData.clear();
      listOfMaps.asMap().forEach((index, row) {
        chartData.add([
          (index + 1).toString(),
          row['cnt'].toString(),
          row['topCode'].toString(),
          row['topName'].toString(),
        ]);
      });
    });
    log("$chartData");
    List<BarCahrtData> newData = [];
    for (var row in chartData) {
      newData.add(BarCahrtData(row[3], double.parse(row[1])));
    }

    // Update the state to trigger a rebuild with the new data
    setState(() {
      data = newData;
    });
  }

   Future<void> TodayInsurers() async {
    setState(() {
      isChecked1=true;
    });
    final formatterYear = DateFormat('yyy');
    final formatterMonth = DateFormat('MM');
    final nowYear = formatterYear.format(DateTime.now());
    final nowMonth = formatterMonth.format(DateTime.now());

    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Top_Insurers",
      data: {"Year": "$nowYear", "Month": "$nowMonth", "Top": "10","UserID": "${widget.user_id}"},
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);
    setState(() {
      chartData.clear();
      listOfMaps.asMap().forEach((index, row) {
        chartData.add([
          (index + 1).toString(),
          row['cnt'].toString(),
          row['topCode'].toString(),
          row['topName'].toString(),
        ]);
      });
    });
    log("$chartData");
    List<BarCahrtData> newData = [];
    for (var row in chartData) {
      newData.add(BarCahrtData(row[3], double.parse(row[1])));
    }

    // Update the state to trigger a rebuild with the new data
    setState(() {
      data = newData;
    });
  }


   Future<void> TodayProfiles() async {
    setState(() {
      isChecked1=true;
    });
    final formatterYear = DateFormat('yyy');
    final formatterMonth = DateFormat('MM');
    final nowYear = formatterYear.format(DateTime.now());
    final nowMonth = formatterMonth.format(DateTime.now());

    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Top_Profiles",
      data: {"Year": "$nowYear", "Month": "$nowMonth", "Top": "10","UserID": "${widget.user_id}"},
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);
    setState(() {
      chartData.clear();
      listOfMaps.asMap().forEach((index, row) {
        chartData.add([
          (index + 1).toString(),
          row['cnt'].toString(),
          row['topCode'].toString(),
          row['topName'].toString(),
        ]);
      });
    });
    log("$chartData");
    List<BarCahrtData> newData = [];
    for (var row in chartData) {
      newData.add(BarCahrtData(row[3], double.parse(row[1])));
    }

    // Update the state to trigger a rebuild with the new data
    setState(() {
      data = newData;
    });
  }


  Future<void> TodayRequestedTest() async {
    setState(() {
      isChecked1=true;
    });
    final formatterYear = DateFormat('yyy');
    final formatterMonth = DateFormat('MM');
    final nowYear = formatterYear.format(DateTime.now());
    final nowMonth = formatterMonth.format(DateTime.now());

    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Top_Requested_Test",
      data: {"Year": "$nowYear", "Month": "$nowMonth", "Top": "10","UserID": "${widget.user_id}"},
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);
    setState(() {
      chartData.clear();
      listOfMaps.asMap().forEach((index, row) {
        chartData.add([
          (index + 1).toString(),
          row['cnt'].toString(),
          row['topCode'].toString(),
          row['topName'].toString(),
        ]);
      });
    });
    log("$chartData");
    List<BarCahrtData> newData = [];
    for (var row in chartData) {
      newData.add(BarCahrtData(row[3], double.parse(row[1])));
    }

    // Update the state to trigger a rebuild with the new data
    setState(() {
      data = newData;
    });
  }

  Future<void> TopReferral() async {
    String month = controllerMonth.text;
    String year = controllerYear.text;
    String top = controllerTop.text;
    try {
      if (int.parse(top) >= 10) {
        responseData = await APIHelper.connect(
          context: context,
          endpoint: "/api/Top_Referral",
          data: {"Year": "$year", "Month": "$month", "Top": "$top","UserID": "${widget.user_id}"},
        );
        Map<String, dynamic> ApiResponse = responseData;

        listOfMaps = convertApiResponseToList(ApiResponse);

        setState(() {
          chartData.clear();
          listOfMaps.asMap().forEach((index, row) {
            chartData.add([
              (index + 1).toString(),
              row['cnt'].toString(),
              row['topCode'].toString(),
              row['topName'].toString(),
            ]);
          });
        });
        log("$chartData");

        List<BarCahrtData> newData = [];
        for (var row in chartData) {
          newData.add(BarCahrtData(row[3], double.parse(row[1])));
        }

        // Update the state to trigger a rebuild with the new data
        setState(() {
          data = newData;
        });
      } else {
        log("there are error");
      }
    } catch (e) {
      log("$e");
    }
  }

  Future<void> TopDoctors() async {
    String month = controllerMonth.text;
    String year = controllerYear.text;
    String top = controllerTop.text;
    try {
      if (int.parse(top) >= 10) {
        responseData = await APIHelper.connect(
          context: context,
          endpoint: "/api/Top_Doctors",
          data: {"Year": "$year", "Month": "$month", "Top": "$top","UserID": "${widget.user_id}"},
        );
        Map<String, dynamic> ApiResponse = responseData;

        listOfMaps = convertApiResponseToList(ApiResponse);

        setState(() {
          chartData.clear();
          listOfMaps.asMap().forEach((index, row) {
            chartData.add([
              (index + 1).toString(),
              row['cnt'].toString(),
              row['topCode'].toString(),
              row['topName'].toString(),
            ]);
          });
        });
        log("$chartData");
        List<BarCahrtData> newData = [];
        for (var row in chartData) {
          newData.add(BarCahrtData(row[3], double.parse(row[1])));
        }

        // Update the state to trigger a rebuild with the new data
        setState(() {
          data = newData;
        });
      } else {
        log("there are error");
      }
    } catch (e) {
      log("$e");
    }
  }

  Future<void> TopInsurers() async {
    String month = controllerMonth.text;
    String year = controllerYear.text;
    String top = controllerTop.text;
    try {
      if (int.parse(top) >= 10) {
        responseData = await APIHelper.connect(
          context: context,
          endpoint: "/api/Top_Insurers",
          data: {"Year": "$year", "Month": "$month", "Top": "$top","UserID": "${widget.user_id}"},
        );
        Map<String, dynamic> ApiResponse = responseData;

        listOfMaps = convertApiResponseToList(ApiResponse);
        setState(() {
          chartData.clear();
          listOfMaps.asMap().forEach((index, row) {
            chartData.add([
              (index + 1).toString(),
              row['cnt'].toString(),
              row['topCode'].toString(),
              row['topName'].toString(),
            ]);
          });
        });
        log("$chartData");
        List<BarCahrtData> newData = [];
        for (var row in chartData) {
          newData.add(BarCahrtData(row[3], double.parse(row[1])));
        }

        // Update the state to trigger a rebuild with the new data
        setState(() {
          data = newData;
        });
      } else {
        log("there are error");
      }
    } catch (e) {
      log("$e");
    }
  }

  Future<void> TopProfiles() async {
    String month = controllerMonth.text;
    String year = controllerYear.text;
    String top = controllerTop.text;
    try {
      if (int.parse(top) >= 10) {
        responseData = await APIHelper.connect(
          context: context,
          endpoint: "/api/Top_Profiles",
          data: {"Year": "$year", "Month": "$month", "Top": "$top","UserID": "${widget.user_id}"},
        );
        Map<String, dynamic> ApiResponse = responseData;

        listOfMaps = convertApiResponseToList(ApiResponse);
        setState(() {
          chartData.clear();
          listOfMaps.asMap().forEach((index, row) {
            chartData.add([
              (index + 1).toString(),
              row['cnt'].toString(),
              row['topCode'].toString(),
              row['topName'].toString(),
            ]);
          });
        });
        log("$chartData");
        List<BarCahrtData> newData = [];
        for (var row in chartData) {
          newData.add(BarCahrtData(row[3], double.parse(row[1])));
        }

        // Update the state to trigger a rebuild with the new data
        setState(() {
          data = newData;
        });
      } else {
        log("there are error");
      }
    } catch (e) {
      log("$e");
    }
  }

  Future<void> TopRequestedTest() async {
    String month = controllerMonth.text;
    String year = controllerYear.text;
    String top = controllerTop.text;
    try {
      if (int.parse(top) >= 10) {
        responseData = await APIHelper.connect(
          context: context,
          endpoint: "/api/Top_Requested_Test",
          data: {"Year": "$year", "Month": "$month", "Top": "$top","UserID": "${widget.user_id}"},
        );
        Map<String, dynamic> ApiResponse = responseData;

        listOfMaps = convertApiResponseToList(ApiResponse);
        setState(() {
          chartData.clear();
          listOfMaps.asMap().forEach((index, row) {
            chartData.add([
              (index + 1).toString(),
              row['cnt'].toString(),
              row['topCode'].toString(),
              row['topName'].toString(),
            ]);
          });
        });
        log("$chartData");
        List<BarCahrtData> newData = [];
        for (var row in chartData) {
          newData.add(BarCahrtData(row[3], double.parse(row[1])));
        }

        // Update the state to trigger a rebuild with the new data
        setState(() {
          data = newData;
        });
      }
    } catch (e) {
      log("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyy');
    final formatter1 = DateFormat('MM');
    final now = DateTime.now();
    String year = formatter.format(now);
    String month = formatter1.format(now);

    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    final Size screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 45.0
                        : MediaQuery.of(context).size.height / 30.0,
                    right: MediaQuery.of(context).size.width / 1.17,
                  ),
                  child: Text("Month",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold))),
              Container(
                margin: EdgeInsets.only(
                  left: isPortrait
                      ? MediaQuery.of(context).size.width / 8.0
                      : MediaQuery.of(context).size.width / 11.0,
                  top: MediaQuery.of(context).size.height / 70.0,
                ),
                child: SizedBox(
                  width: isPortrait
                      ? MediaQuery.of(context).size.width / 5.5
                      : MediaQuery.of(context).size.width / 9.0,
                  height: isPortrait
                      ? MediaQuery.of(context).size.height / 20.0
                      : MediaQuery.of(context).size.height / 10.0,
                  child: Padding(
                    padding: isPortrait
                        ? EdgeInsets.only(bottom: 8.0)
                        : EdgeInsets.only(bottom: 0.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: controllerMonth,
                      onSubmitted: (value) {
                        setState(() {
                          if (isChecked1) {
                            TopRequestedTest();
                          }
                          if (isChecked2) {
                            TopProfiles();
                          }
                          if (isChecked3) {
                            TopInsurers();
                          }
                          if (isChecked4) {
                            TopDoctors();
                          }
                          if (isChecked5) {
                            TopReferral();
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: month,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: isPortrait
                                ? MediaQuery.of(context).size.width / 50.0
                                : MediaQuery.of(context).size.width / 50.0),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: isPortrait
                      ? MediaQuery.of(context).size.width / 3.0
                      : MediaQuery.of(context).size.width / 4.7,
                  top: MediaQuery.of(context).size.height / 70.0,
                ),
                child: SizedBox(
                  width: isPortrait
                      ? MediaQuery.of(context).size.width / 5.5
                      : MediaQuery.of(context).size.width / 9.0,
                  height: isPortrait
                      ? MediaQuery.of(context).size.height / 20.0
                      : MediaQuery.of(context).size.height / 10.0,
                  child: Padding(
                    padding: isPortrait
                        ? EdgeInsets.only(bottom: 8.0)
                        : EdgeInsets.only(bottom: 0.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: controllerYear,
                      onSubmitted: (value) {
                        setState(() {
                          if (isChecked1) {
                            TopRequestedTest();
                          }
                          if (isChecked2) {
                            TopProfiles();
                          }
                          if (isChecked3) {
                            TopInsurers();
                          }
                          if (isChecked4) {
                            TopDoctors();
                          }
                          if (isChecked5) {
                            TopReferral();
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: year,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: isPortrait
                                ? MediaQuery.of(context).size.width / 50.0
                                : MediaQuery.of(context).size.width / 50.0),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: isPortrait
                      ? MediaQuery.of(context).size.height / 45.0
                      : MediaQuery.of(context).size.height / 30.0,
                  left: isPortrait
                      ? MediaQuery.of(context).size.width / 1.8
                      : MediaQuery.of(context).size.width / 2.6,
                ),
                child: Text("Top",
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: isPortrait
                      ? MediaQuery.of(context).size.width / 1.57
                      : MediaQuery.of(context).size.width / 2.3,
                  top: MediaQuery.of(context).size.height / 70.0,
                ),
                child: SizedBox(
                  width: isPortrait
                      ? MediaQuery.of(context).size.width / 5.5
                      : MediaQuery.of(context).size.width / 9.0,
                  height: isPortrait
                      ? MediaQuery.of(context).size.height / 20.0
                      : MediaQuery.of(context).size.height / 10.0,
                  child: Padding(
                    padding: isPortrait
                        ? EdgeInsets.only(bottom: 8.0)
                        : EdgeInsets.only(bottom: 0.0),
                    child: TextField(
                    
                      keyboardType: TextInputType.number,
                      controller: controllerTop,
                      onSubmitted: (value) {
                        setState(() {
                          if (isChecked1) {
                            TopRequestedTest();
                          }
                          if (isChecked2) {
                            TopProfiles();
                          }
                          if (isChecked3) {
                            TopInsurers();
                          }
                          if (isChecked4) {
                            TopDoctors();
                          }
                          if (isChecked5) {
                            TopReferral();
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "10",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: isPortrait
                                ? MediaQuery.of(context).size.width / 50.0
                                : MediaQuery.of(context).size.width / 50.0),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 11.7
                        : MediaQuery.of(context).size.height / 7.0),
                child: Checkbox(
                    value: isChecked1,
                    activeColor: Color(0xff1f63b6),
                    onChanged: (value) {
                      setState(() {
                        if (isChecked1 = value!) {
                            if(controllerMonth.text.isEmpty&&controllerYear.text.isEmpty&&controllerTop.text.isEmpty){
                          TodayRequestedTest();
                         }
                         else{
                          TopRequestedTest();
                         }
                        }
                      });
                      isChecked2 = false;
                      isChecked3 = false;
                      isChecked4 = false;
                      isChecked5 = false;
                    }),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 10.0
                        : MediaQuery.of(context).size.height / 6.0,
                    left: isPortrait
                        ? MediaQuery.of(context).size.width / 9.0
                        : MediaQuery.of(context).size.width / 18.0),
                child: Text(
                  "Top Requested Tests this month",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 7.7
                        : MediaQuery.of(context).size.height / 4.5),
                child: Checkbox(
                    value: isChecked2,
                    activeColor: Color(0xff1f63b6),
                    onChanged: (value) {
                      setState(() {
                        if (isChecked2 = value!) {
                         if(controllerMonth.text.isEmpty&&controllerYear.text.isEmpty&&controllerTop.text.isEmpty){
                          TodayProfiles();
                         }
                         else{
                          TopProfiles();
                         }
                        }
                      });
                      isChecked1 = false;
                      isChecked3 = false;
                      isChecked4 = false;
                      isChecked5 = false;
                    }),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 7.0
                        : MediaQuery.of(context).size.height / 4.0,
                    left: isPortrait
                        ? MediaQuery.of(context).size.width / 9.0
                        : MediaQuery.of(context).size.width / 18.0),
                child: Text(
                  "Top Profiles/Packages this month",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 5.8
                        : MediaQuery.of(context).size.height / 3.3),
                child: Checkbox(
                    value: isChecked3,
                    activeColor: Color(0xff1f63b6),
                    onChanged: (value) {
                      setState(() {
                        if (isChecked3 = value!) {
                           if(controllerMonth.text.isEmpty&&controllerYear.text.isEmpty&&controllerTop.text.isEmpty){
                          TodayInsurers();
                         }
                         else{
                          TopInsurers();
                         }
                        }
                      });
                      isChecked1 = false;
                      isChecked2 = false;
                      isChecked4 = false;
                      isChecked5 = false;
                    }),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 5.4
                        : MediaQuery.of(context).size.height / 3.0,
                    left: isPortrait
                        ? MediaQuery.of(context).size.width / 9.0
                        : MediaQuery.of(context).size.width / 18.0),
                child: Text(
                  "Top Insurers this month",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 4.7
                        : MediaQuery.of(context).size.height / 2.58),
                child: Checkbox(
                  value: isChecked4,
                  activeColor: Color(0xff1f63b6),
                  onChanged: (value) {
                    setState(() {
                      if (isChecked4 = value!) {
                      if(controllerMonth.text.isEmpty&&controllerYear.text.isEmpty&&controllerTop.text.isEmpty){
                          TodayDoctors();
                         }
                         else{
                          TopDoctors();
                         }
                      }
                    });
                    isChecked1 = false;
                    isChecked2 = false;
                    isChecked3 = false;
                    isChecked5 = false;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 4.4
                        : MediaQuery.of(context).size.height / 2.4,
                    left: isPortrait
                        ? MediaQuery.of(context).size.width / 9.0
                        : MediaQuery.of(context).size.width / 18.0),
                child: Text(
                  "Top Doctors this month",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: isPortrait
                      ? MediaQuery.of(context).size.height / 3.9
                      : MediaQuery.of(context).size.height / 2.12,
                ),
                child: Checkbox(
                  value: isChecked5,
                  activeColor: Color(0xff1f63b6),
                  onChanged: (value) {
                    setState(() {
                      if (isChecked5 = value!) {
                         if(controllerMonth.text.isEmpty&&controllerYear.text.isEmpty&&controllerTop.text.isEmpty){
                          TodayReferral();
                         }
                         else{
                         TopReferral();
                         }
                      }
                    });
                    isChecked1 = false;
                    isChecked2 = false;
                    isChecked3 = false;
                    isChecked4 = false;
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(
                      top: isPortrait
                          ? MediaQuery.of(context).size.height / 3.7
                          : MediaQuery.of(context).size.height / 2.0,
                      left: isPortrait
                          ? MediaQuery.of(context).size.width / 9.0
                          : MediaQuery.of(context).size.width / 18.0),
                  child: Text(
                    "Top Referral Labs this month",
                    style: TextStyle(fontSize: 18.0),
                  )),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  _buildTableHeader(),
                  Container(
                    height: screenSize.height / 2.1,
                    child: SingleChildScrollView(
                      child: Table(
                        border: TableBorder.all(
                          style: BorderStyle.solid,
                          color: Color.fromARGB(255, 228, 224, 224),
                        ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: {
                          0: FixedColumnWidth(
                              screenSize.width * 0.23), // Test_Code
                          1: FixedColumnWidth(
                              screenSize.width * 0.26), // Test_Name
                          2: FixedColumnWidth(
                              screenSize.width * 0.26), // VisS_Result
                          3: FixedColumnWidth(
                              screenSize.width * 0.29), // Nor_Conventional
                        },
                        children: [
                          for (List<String> rowData in chartData)
                            _buildTableRow(rowData),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 20.0,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: MediaQuery.of(context).size.width * 2.3,
              height: MediaQuery.of(context).size.height * 0.5,
              child: SfCartesianChart(
                legend: Legend(isVisible: true, position: LegendPosition.top),
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: CategoryAxis(
                  majorGridLines: MajorGridLines(
                    color: Colors.grey,
                  ),
                  majorTickLines: MajorTickLines(
                    color: Colors.black,
                    size: 6,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: MajorGridLines(
                    color: Colors.grey,
                  ),
                  majorTickLines: MajorTickLines(
                    color: Colors.black,
                    size: 10,
                  ),
                ),
                series: <CartesianSeries<BarCahrtData, String>>[
                  BarSeries<BarCahrtData, String>(
                    color: Color(0xff1f63b6),
                    name: "Samples",
                    dataSource: data,
                    xValueMapper: (BarCahrtData datum, _) => datum.code,
                    yValueMapper: (BarCahrtData datum, _) => datum.value,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      // Set the label position to top
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

  Widget _buildTableHeader() {
    return Container(
      color: Color(0xff1f63b6),
      child: Row(
        children: [
          _buildTableHeaderCell('Seq', 0),
          _buildTableHeaderCell('Code', 1),
          _buildTableHeaderCell('Name', 2),
          _buildTableHeaderCell('Samples', 3),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text, int columnIndex) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width * 0.26,
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> rowData) {
    return TableRow(children: [
      _buildTableCell(rowData[0], 0),
      _buildTableCell(rowData[2], 1),
      _buildTableCell(rowData[3], 2),
      _buildTableCell(rowData[1], 3)
    ]);
  }

  TableCell _buildTableCell(
    String text,
    int columnIndex,
  ) {
    return TableCell(
      child: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class BarCahrtData {
  final String code;
  final double value;
  BarCahrtData(this.code, this.value);
}
