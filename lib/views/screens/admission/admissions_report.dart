import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../API_connect/API_connect.dart';
import '../../../widgets/admissions_class.dart';
import '../../../widgets/admissions_table.dart';
import 'dart:convert';
import 'package:diagnostic/global_variable/globals.dart' as globals;


class AdmissionReport extends StatefulWidget {
  final String username;
  final String UserId;
  final String branch_id;
  const AdmissionReport(
      {super.key,
      required this.username,
      required this.UserId,
      required this.branch_id});

  @override
  State<AdmissionReport> createState() => _AdmissionReportState();
}

class _AdmissionReportState extends State<AdmissionReport> {
  final List<List<String>> tableData = [];
  List<List<String>> foundPatients = [];
  late String textField1Value = '';
  late String textField2Value;
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];

  @override
  void initState() {
    super.initState();
    log("${widget.branch_id}");
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    Future.delayed(Duration(seconds: 1), () {
      _fetchTodaysData();
    });
    textField1Value = formatter.format(now);
    textField2Value = formatter.format(now);
  }

  void _runSearch(String enteredKeyword) {
    List<List<String>> results = [];
// if the search field is empty or only contains white-space, we'll display all data
    if (enteredKeyword.isEmpty) {
      results = tableData;
    } else {
      results = tableData
          .where((patient) =>
              patient[2].toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              patient[0].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      foundPatients = results;
    });
  }

  String stripMargin(var s) {
    String z = "";
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(s.toString());

    for (var i = 0; i < lines.length; i++) {
      z += lines[i].trim() + " ";
    }

    return z;
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
      final formatter = DateFormat('yyyy-MM-dd');
      setState(() {
        startDate = picked;
        textField1Value = formatter.format(picked);
        ResultReportData();
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
      final formatter = DateFormat('yyyy-MM-dd');
      setState(() {
        endDate = picked;
        textField2Value = formatter.format(picked);
        ResultReportData();
      });
    }
  }

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('SampleList') &&
        apiResponse['SampleList'] is List) {
      List<dynamic> data = apiResponse['SampleList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }

  Future<void> _fetchTodaysData() async {
    final formatter = DateFormat('yyyy-MM-dd');
    final now = DateTime.now();
    final todayDate = formatter.format(now);

    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/AllSamples",
      data: {
        "startDate": "$todayDate",
        "endDate": "$todayDate",
        "BranchID": "${widget.branch_id}"
      },
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);

    setState(() {
      tableData.clear();
      listOfMaps.forEach((row) {
        DateTime payDate =
            DateFormat('M/d/yyyy h:mm:ss a').parse(row['payDate']);
        tableData.add([
          row['vism_seq'].toString(),
          DateFormat('yyy-MM-dd').format(payDate),
          stripMargin(row['patname']),
          row['Finalize'].toString()
        ]);
      });
      foundPatients = tableData;
    });
  }

  Future<void> ResultReportData() async {
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
      final formatter = DateFormat('yyyy-MM-dd');
      final startDateString = formatter.format(startDate!);
      final now = DateTime.now();
      final endDateString = formatter.format(now);
      responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/AllSamples",
        data: {
          "startDate": "$startDateString",
          "endDate": "$endDateString",
          "BranchID": "${widget.branch_id}"
        },
      );
      Map<String, dynamic> ApiResponse = responseData;

      listOfMaps = convertApiResponseToList(ApiResponse);

      setState(() {
        tableData.clear();
        listOfMaps.forEach((row) {
          DateTime payDate =
              DateFormat('M/d/yyyy h:mm:ss a').parse(row['payDate']);
          tableData.add([
            row['vism_seq'].toString(),
            DateFormat('yyy-MM-dd').format(payDate),
            stripMargin(row['patname']),
            row['Finalize'].toString()
          ]);
        });
       
        isLoading = false;
        Navigator.of(context).pop();
        foundPatients = tableData;
        // log("$foundPatients");
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
      final formatter = DateFormat('yyyy-MM-dd');
      final startDateString = formatter.format(startDate!);
      final formatter2 = DateFormat('yyy-MM-dd');
      final endDateString = formatter2.format(endDate!);
      responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/AllSamples",
        data: {
          "startDate": "$startDateString",
          "endDate": "$endDateString",
          "BranchID": "${widget.branch_id}"
        },
      );
      Map<String, dynamic> ApiResponse = responseData;
      listOfMaps = convertApiResponseToList(ApiResponse);
      setState(() {
        tableData.clear();
        listOfMaps.forEach((row) {
          DateTime payDate =
              DateFormat('M/d/yyyy h:mm:ss a').parse(row['payDate']);
          tableData.add([
            row['vism_seq'].toString(),
            DateFormat('yyy-MM-dd').format(payDate),
            stripMargin(row['patname']),
            row['Finalize'].toString()
          ]);
        });
        
        isLoading = false;
        Navigator.of(context).pop();
        foundPatients = tableData;
        // log("$foundPatients");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admission',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 15.0
                        : MediaQuery.of(context).size.height / 15.0,
                    right: isPortrait
                        ? MediaQuery.of(context).size.width / 6.6
                        : MediaQuery.of(context).size.width / 10.0,
                  ),
                  width: MediaQuery.of(context).size.width / 2.7,
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: textField1Value),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Color(0xff1f63b6)),
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
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 15.0
                        : MediaQuery.of(context).size.height / 15.0,
                    left: isPortrait
                        ? MediaQuery.of(context).size.width / 2.0
                        : MediaQuery.of(context).size.width / 2.0,
                  ),
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: textField2Value),
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

                ////////

                Container(
                  width: MediaQuery.of(context).size.width / 1.12,
                  margin: EdgeInsets.only(
                      top: isPortrait
                          ? MediaQuery.of(context).size.height / 6.0
                          : MediaQuery.of(context).size.height / 3.0),
                  child: TextField(
                    onChanged: (value) => _runSearch(value),
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: const Color(0xff1f63b6)),
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
                        hintText: "Search....",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder()),
                  ),
                ),

                ////////
              ],
            ),

            Container(
              margin: EdgeInsets.only(
                  top: isPortrait
                      ? MediaQuery.of(context).size.height / 10.0
                      : MediaQuery.of(context).size.height / 7.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    AdmissionsTable(
                      finalize:globals.finalize ,
                      username: widget.username,
                      contacts: foundPatients.map((rowData) {
                        return results(
                            sampleNo: int.parse(rowData[0]),
                            date: rowData[1],
                            patientName: rowData[2],
                            finalize: rowData[3]);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: isPortrait
                  ? MediaQuery.of(context).size.height / 10.0
                  : MediaQuery.of(context).size.height / 10.0,
            ),

            //////////////
          ],
        ),
      ),
    );
  }
}
