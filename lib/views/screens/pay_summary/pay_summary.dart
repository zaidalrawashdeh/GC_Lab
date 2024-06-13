import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import '../../../API_connect/API_connect.dart';

class PaymentSummary extends StatefulWidget {
  final String branch_id;
  final String user_id;
  const PaymentSummary(
      {super.key, required this.branch_id, required this.user_id});

  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  List<List<String>> tableData = [];

  late String textStartDate = '';
  late String textEndDate = '';
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];
  List<Map<String, dynamic>> listOfMaps2 = [];
  String branches = '';
  String branch_ID = '';

  late String paidCash = '';
  late String paidPrevCash = '';
  late String netCash = '';
  late String paidVisa = '';
  late String paidPrevVisa = '';
  late String netVisa = '';
  late String paidPrevCheck = '';
  late String netCheck = '';
  late String totalPayment = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy');
    textStartDate = formatter.format(now);
    textEndDate = formatter.format(now);
    Future.delayed(Duration(seconds: 1), () {
      branchesOfUser().then((value) {
        getBr_seq();
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      _fetchTodaysData("0");
    });
  }

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList2(
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

  Future<void> branchesOfUser() async {
    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Branchs",
      data: {"UserID": "${widget.user_id}"},
    );
    Map<String, dynamic> ApiResponse = responseData;
    listOfMaps2 = convertApiResponseToList2(ApiResponse);
  }

  Map<String, dynamic> branchNameToBrSeqMap = {};
  void getBr_seq() {
    for (var data in listOfMaps2) {
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
    if (apiResponse.containsKey('IncomeQueryList') &&
        apiResponse['IncomeQueryList'] is List) {
      List<dynamic> data = apiResponse['IncomeQueryList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff1f63b6), // Set the primary color to blue
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatter = DateFormat('dd-MM-yyyy');
      setState(() {
        startDate = picked;
        textStartDate = formatter.format(picked);
        SummaryIncome();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff1f63b6), // Set the primary color to blue
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatter = DateFormat('dd-MM-yyyy');
      setState(() {
        endDate = picked;
        textEndDate = formatter.format(picked);
        SummaryIncome();
      });
    }
  }

  Future<void> _fetchTodaysData(String id_branch) async {
    final formatter = DateFormat('dd-MM-yyyy');
    final now = DateTime.now();
    final todayData = formatter.format(now);
    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/IncomeQuery",
      data: {
        "stdate": "$todayData",
        "endDate": "$todayData",
        "BranchID": "$id_branch",
        "UserID": "${widget.user_id}"
      },
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);
    setState(() {
      tableData.clear();
      listOfMaps.forEach((row) {
        tableData.add([
          row['cashAmount'],
          row['cashPrevAmount'],
          row['NetCash'],
          row['visaAmount'],
          row['VisaPrevAmount'],
          row['NetVisa'],
          row['chequePrevAmount'],
          row['NetCheck'],
          row['Total'],
        ]);
      });
      print("$tableData");
      paidCash = "${tableData[0][0]}";
      paidPrevCash = "${tableData[0][1]}";
      netCash = "${tableData[0][2]}";
      paidVisa = "${tableData[0][3]}";
      paidPrevVisa = "${tableData[0][4]}";
      netVisa = "${tableData[0][5]}";
      paidPrevCheck = "${tableData[0][6]}";
      netCheck = "${tableData[0][7]}";
      totalPayment = "${tableData[0][8]}";
    });
  }

  Future<void> SummaryIncome({String id_branch = "0"}) async {
    if (startDate != null) {
      setState(() {
        isLoading = true;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: GestureDetector(
              // Ignore clicking on the inner content of the dialog
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Loading....",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            backgroundColor: Color(0xff1f63b6),
          );
        },
      );

      final formatter = DateFormat('dd-MM-yyyy');
      final startDateString = formatter.format(startDate!);
      final now = DateTime.now();
      final endDateString = formatter.format(now);
      responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/IncomeQuery",
        data: {
        "stdate": "$startDateString",
        "endDate": "$endDateString",
        "BranchID": "$id_branch",
        "UserID": "${widget.user_id}"
        },
      );
      Map<String, dynamic> ApiResponse = responseData;
print ("${ApiResponse.toString()}");
      listOfMaps = convertApiResponseToList(ApiResponse);
      setState(() {
        tableData.clear();
        listOfMaps.forEach((row) {

          tableData.add([
            row['cashAmount'].toString(),
            row['cashPrevAmount'].toString(),
            row['NetCash'].toString(),
            row['visaAmount'].toString(),
            row['VisaPrevAmount'].toString(),
            row['NetVisa'].toString(),
            row['chequePrevAmount'].toString(),
            row['NetCheck'].toString(),
            row['Total'].toString(),
          ]);
        });
        print("$tableData");
        paidCash = "${tableData[0][0]}";
      paidPrevCash = "${tableData[0][1]}";
      netCash = "${tableData[0][2]}";
      paidVisa = "${tableData[0][3]}";
      paidPrevVisa = "${tableData[0][4]}";
      netVisa = "${tableData[0][5]}";
      paidPrevCheck = "${tableData[0][6]}";
      netCheck = "${tableData[0][7]}";
      totalPayment = "${tableData[0][8]}";
        isLoading = false;
        Navigator.of(context).pop();
      });
    }

    if (endDate != null) {
      setState(() {
        isLoading = true;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: GestureDetector(
              // Ignore clicking on the inner content of the dialog
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Loading....",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            backgroundColor: Color(0xff1f63b6),
          );
        },
      );

      final formatter = DateFormat('dd-MM-yyyy');
      final startDateString = formatter.format(startDate!);
      final formatter2 = DateFormat('dd-MM-yyyy');
      final endDateString = formatter2.format(endDate!);
      responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/IncomeQuery",
        data: {
          "stdate": "$startDateString",
        "endDate": "$endDateString",
        "BranchID": "$id_branch",
        "UserID": "${widget.user_id}"
        },
      );
      Map<String, dynamic> ApiResponse = responseData;

      listOfMaps = convertApiResponseToList(ApiResponse);
      setState(() {
        tableData.clear();
        listOfMaps.forEach((row) {
          tableData.add([
            row['cashAmount'].toString(),
            row['cashPrevAmount'].toString(),
            row['NetCash'].toString(),
            row['visaAmount'].toString(),
            row['VisaPrevAmount'].toString(),
            row['NetVisa'].toString(),
            row['chequePrevAmount'].toString(),
            row['NetCheck'].toString(),
            row['Total'].toString(),
          ]);
        });
        print("$tableData");

        paidCash = "${tableData[0][0]}";
      paidPrevCash = "${tableData[0][1]}";
      netCash = "${tableData[0][2]}";
      paidVisa = "${tableData[0][3]}";
      paidPrevVisa = "${tableData[0][4]}";
      netVisa = "${tableData[0][5]}";
      paidPrevCheck = "${tableData[0][6]}";
      netCheck = "${tableData[0][7]}";
      totalPayment = "${tableData[0][8]}";
        isLoading = false;
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Summary"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 25.0,
                    left: MediaQuery.of(context).size.width / 30.0,
                  ),
                  width: MediaQuery.of(context).size.width / 2.7,
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: textStartDate),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: const Color(0xff1f63b6)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: const Color(0xff1f63b6),
                        ),
                      ),
                      labelText: 'Start Date',
                    ),
                    onTap: () => _selectStartDate(context),
                  ),
                ),

                //////////////
                Container(
                  width: MediaQuery.of(context).size.width / 2.7,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 25.0,
                    left: MediaQuery.of(context).size.width / 5.0,
                  ),
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: textEndDate),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: const Color(0xff1f63b6)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: const Color(0xff1f63b6),
                        ),
                      ),
                      labelText: 'End Date',
                    ),
                    onTap: () => _selectEndDate(context),
                  ),
                ),

                ///////////////////////////////////////////////////////////////////
              ],
            ),
            ///////////////////////////////////////////////////////////////////

            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 20.0,
                  right: MediaQuery.of(context).size.width / 1.5),
              child: Text("Select Branch:"),
            ),

            ///////////////////////////////////////////////////////////////////
            Container(
              width: MediaQuery.of(context).size.width / 2.6,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 60.0,
                right: MediaQuery.of(context).size.width / 1.8,
              ),
              child: SearchField(
                suggestionStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                suggestionsDecoration: SuggestionDecoration(
                  color: const Color(0xff1f63b6),
                ),
                suggestionDirection: SuggestionDirection.down,
                onSubmit: (value) {
                  setState(() {
                    if (value.isNotEmpty &&
                        (textStartDate ==
                                "${DateFormat('yyy-MM-dd').format(DateTime.now())}" &&
                            textEndDate ==
                                "${DateFormat('yyy-MM-dd').format(DateTime.now())}")) {
                      branches = value;
                      branch_ID = branchNameToBrSeqMap[branches];
                      _fetchTodaysData(branch_ID);
                      log("$branch_ID");
                    } else if (value.isEmpty &&
                        (textStartDate ==
                                "${DateFormat('yyy-MM-dd').format(DateTime.now())}" &&
                            textEndDate ==
                                "${DateFormat('yyy-MM-dd').format(DateTime.now())}")) {
                      log("message");
                      _fetchTodaysData('0');
                    } else if (value.isEmpty) {
                      SummaryIncome(id_branch: "0");
                    } else {
                      branches = value;
                      branch_ID = branchNameToBrSeqMap[branches];
                      SummaryIncome(id_branch: branch_ID);
                      log("$branch_ID");
                    }
                  });
                },
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
                suggestions: listOfMaps2.map((data) {
                  // Extract 'BranchName' from each map and convert it to a string
                  final branchName = data['BranchName'] as String;
                  return SearchFieldListItem<String>(branchName);
                }).toList(),
              ),
            ),

            ///////////////////////////////////////////////////////////////////
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 40.0),
                  child: Divider(
                    color: Color(0xff1f63b6),
                    thickness: 30.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2.7,
                      top: MediaQuery.of(context).size.height / 80.0),
                  child: Text(
                    "Cash Summary",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 30.0,
                      top: MediaQuery.of(context).size.height / 80.0),
                  child: Text(
                    "Paid Cash",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 80.0,
                      left: MediaQuery.of(context).size.width / 20.0),
                  width: MediaQuery.of(context).size.width / 2.0,
                  height: MediaQuery.of(context).size.height / 25.0,
                  child: TextField(
                    controller: TextEditingController(text: paidCash),
                    cursorColor: Color(0xff1f63b6),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            ////////////////////////////////////////////
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 30.0,
                      top: MediaQuery.of(context).size.height / 30.0),
                  child: Text(
                    "Paid Prev. Cash",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30.0,
                      left: MediaQuery.of(context).size.width / 20.0),
                  width: MediaQuery.of(context).size.width / 2.0,
                  height: MediaQuery.of(context).size.height / 25.0,
                  child: TextField(
                    controller: TextEditingController(text: paidPrevCash),
                    cursorColor: Color(0xff1f63b6),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////////////////////
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 30.0,
                      top: MediaQuery.of(context).size.height / 30.0),
                  child: Text(
                    "Net Cash",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30.0,
                      left: MediaQuery.of(context).size.width / 20.0),
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: MediaQuery.of(context).size.height / 25.0,
                  child: TextField(
                    controller: TextEditingController(text: netCash),
                    cursorColor: Color(0xff1f63b6),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////////////////
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 20.0),
                  child: Divider(
                    color: Color(0xff1f63b6),
                    thickness: 30.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2.7,
                      top: MediaQuery.of(context).size.height / 27.0),
                  child: Text(
                    "Visa Summary",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            ///////////////////////////////////////////////////
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 30.0,
                      top: MediaQuery.of(context).size.height / 80.0),
                  child: Text(
                    "Paid Visa",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 80.0,
                      left: MediaQuery.of(context).size.width / 20.0),
                  width: MediaQuery.of(context).size.width / 2.0,
                  height: MediaQuery.of(context).size.height / 25.0,
                  child: TextField(
                    controller: TextEditingController(text: paidVisa),
                    cursorColor: Color(0xff1f63b6),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////////
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 30.0,
                      top: MediaQuery.of(context).size.height / 30.0),
                  child: Text(
                    "Paid Prev. Visa",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30.0,
                      left: MediaQuery.of(context).size.width / 20.0),
                  width: MediaQuery.of(context).size.width / 2.0,
                  height: MediaQuery.of(context).size.height / 25.0,
                  child: TextField(
                    controller: TextEditingController(text: paidPrevVisa),
                    cursorColor: Color(0xff1f63b6),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////////////////////
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 30.0,
                      top: MediaQuery.of(context).size.height / 30.0),
                  child: Text(
                    "Net Visa",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30.0,
                      left: MediaQuery.of(context).size.width / 20.0),
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: MediaQuery.of(context).size.height / 25.0,
                  child: TextField(
                    controller: TextEditingController(text: netVisa),
                    cursorColor: Color(0xff1f63b6),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////////////////
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 20.0),
                  child: Divider(
                    color: Color(0xff1f63b6),
                    thickness: 30.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2.7,
                      top: MediaQuery.of(context).size.height / 27.0),
                  child: Text(
                    "Check Summary",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////////
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 30.0,
                      top: MediaQuery.of(context).size.height / 30.0),
                  child: Text(
                    "Paid Prev. Check",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30.0,
                      left: MediaQuery.of(context).size.width / 20.0),
                  width: MediaQuery.of(context).size.width / 2.0,
                  height: MediaQuery.of(context).size.height / 25.0,
                  child: TextField(
                    controller: TextEditingController(text: paidPrevCheck),
                    cursorColor: Color(0xff1f63b6),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////////////////////
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 30.0,
                      top: MediaQuery.of(context).size.height / 30.0),
                  child: Text(
                    "Net Check",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30.0,
                      left: MediaQuery.of(context).size.width / 20.0),
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: MediaQuery.of(context).size.height / 25.0,
                  child: TextField(
                    controller: TextEditingController(text: netCheck),
                    cursorColor: Color(0xff1f63b6),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////////////////
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 20.0),
                  child: Divider(
                    color: Color(0xff1f63b6),
                    thickness: 30.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2.1,
                      top: MediaQuery.of(context).size.height / 27.0),
                  child: Text(
                    "Total",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////////
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 30.0,
                      top: MediaQuery.of(context).size.height / 30.0),
                  child: Text(
                    "Total Payment",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30.0,
                      left: MediaQuery.of(context).size.width / 20.0),
                  width: MediaQuery.of(context).size.width / 2.0,
                  height: MediaQuery.of(context).size.height / 25.0,
                  child: TextField(
                    controller: TextEditingController(text: totalPayment),
                    cursorColor: Color(0xff1f63b6),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff1f63b6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
