import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:searchfield/searchfield.dart';
import '../../../API_connect/API_connect.dart';
import '../../../widgets/visa_table.dart';
import 'package:open_file/open_file.dart';

class VisaReport extends StatefulWidget {
  final String username;
  final String branch_id;
  final String user_id;
  const VisaReport(
      {super.key,
      required this.username,
      required this.branch_id,
      required this.user_id});

  @override
  State<VisaReport> createState() => _VisaReportState();
}

class _VisaReportState extends State<VisaReport> {
  final List<List<String>> tableData = [];
  List<List<String>> foundPatients = [];
  late String textStartDate = '';
  late String textEndDate;
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];
  List<Map<String, dynamic>> listOfMaps2 = [];
  String branches = '';
  String branch_ID = '';
  double t1 = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
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

  String stripMargin(var s) {
    String z = "";
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(s.toString());

    for (var i = 0; i < lines.length; i++) {
      z += lines[i].trim() + " ";
    }

    return z;
  }

  void _runSearch(String enteredKeyword) {
    List<List<String>> results = [];
// if the search field is empty or only contains white-space, we'll display all data
    if (enteredKeyword.isEmpty) {
      results = tableData;
    } else {
      results = tableData
          .where((patient) =>
              patient[3].toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              patient[0].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      foundPatients = results;
    });
  }

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('VisaList') &&
        apiResponse['VisaList'] is List) {
      List<dynamic> data = apiResponse['VisaList'];

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
      final formatter = DateFormat('yyyy-MM-dd');
      setState(() {
        startDate = picked;
        textStartDate = formatter.format(picked);
        VisaReportTable();
        // if (branch_ID.isEmpty) {
        //   VisaReportTable('0');
        // } else {
        //   VisaReportTable(branch_ID);
        // }
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
        textEndDate = formatter.format(picked);
        VisaReportTable();
        // if (branch_ID.isEmpty) {
        //   VisaReportTable('0');
        // } else {
        //   VisaReportTable(branch_ID);
        // }
      });
    }
  }

  Future<void> _fetchTodaysData(String id_branch) async {
    final formatter = DateFormat('yyyy-MM-dd');

    final now = DateTime.now();
    final todayDate = formatter.format(now);
    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/VisaReport",
      data: {
        "startDate": "$todayDate",
        "endDate": "$todayDate",
        "BranchID": "$id_branch",
        "UserID": "${widget.user_id}"
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
          row['br_code'],
          DateFormat('yyy-MM-dd').format(payDate),
          stripMargin(row['patname']),
          row['VisP_CrtUser'],
          row['VisP_Amount'].toString(),
        ]);
      });

      foundPatients = tableData;
    });
    double total1 = 0.0;
    if (tableData.isEmpty) {
      t1 = 0.0;
    } else {
      for (int i = 0; i < tableData.length; i++) {
        total1 = total1 + double.parse(tableData[i][5]);
        t1 = total1;
      }
    }
  }

  Future<void> VisaReportTable({String id_branch = "0"}) async {
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
        endpoint: "/api/VisaReport",
        data: {
          "startDate": "$startDateString",
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
          DateTime payDate =
              DateFormat('M/d/yyyy h:mm:ss a').parse(row['payDate']);
          tableData.add([
            row['vism_seq'].toString(),
            row['br_code'],
            DateFormat('yyy-MM-dd').format(payDate),
            stripMargin(row['patname']),
            row['VisP_CrtUser'],
            row['VisP_Amount'].toString(),
          ]);
        });

        isLoading = false;
        Navigator.of(context).pop();
        foundPatients = tableData;
      });
      double total1 = 0.0;
      if (tableData.isEmpty) {
        t1 = 0.0;
      } else {
        for (int i = 0; i < tableData.length; i++) {
          total1 = total1 + double.parse(tableData[i][5]);
          t1 = total1;
        }
      }
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
      final formatter2 = DateFormat('yyyy-MM-dd');
      final endDateString = formatter2.format(endDate!);
      responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/VisaReport",
        data: {
          "startDate": "$startDateString",
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
          DateTime payDate =
              DateFormat('M/d/yyyy h:mm:ss a').parse(row['payDate']);
          tableData.add([
            row['vism_seq'].toString(),
            row['br_code'],
            DateFormat('yyy-MM-dd').format(payDate),
            stripMargin(row['patname']),
            row['VisP_CrtUser'],
            row['VisP_Amount'].toString(),
          ]);
        });
        isLoading = false;
        Navigator.of(context).pop();
        foundPatients = tableData;
      });
      double total1 = 0.0;
      if (tableData.isEmpty) {
        t1 = 0.0;
      } else {
        for (int i = 0; i < tableData.length; i++) {
          total1 = total1 + double.parse(tableData[i][5]);
          t1 = total1;
        }
      }
    }
  }

  Future<void> _downloadAsPDF(BuildContext context) async {
    final pdf = pw.Document();

    final headers = [
      'Sample No',
      'Branch',
      'Date',
      'Patient Name',
      'User',
      'Amount'
    ];

    // Load the Cairo font
    final cairoFontData = await rootBundle.load('fonts/Amiri-Regular.ttf');
    final cairoFont = pw.Font.ttf(cairoFontData);

    final rowsPerPage = 16; // Number of rows to display per page
    final totalRows = tableData.length;
    final totalPages = (totalRows / rowsPerPage).ceil();

    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      final startRow = pageIndex * rowsPerPage;
      final endRow = (pageIndex + 1) * rowsPerPage;
      final currentPageData =
          tableData.sublist(startRow, endRow < totalRows ? endRow : totalRows);

      pdf.addPage(
        pw.Page(
          build: (pw.Context pageContext) {
            return pw.Stack(
              children: [
                pw.Container(
                  margin: pw.EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 2.2,
                  ),
                  child: pw.Text(
                    "Visa Report",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                    top: MediaQuery.of(context).size.width / 6.3,
                    left: MediaQuery.of(context).size.width / 1.41,
                  ),
                  child: pw.Text(
                    'Period: $textStartDate   -   $textEndDate',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 10.0),
                  child: pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.grey,
                      width: 0.5,
                    ),
                    columnWidths: {
                      for (int i = 0; i < headers.length; i++)
                        if (i == 3)
                          i: pw.FlexColumnWidth(2)
                        else
                          i: pw.FlexColumnWidth(1),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          for (final header in headers)
                            pw.Container(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                header,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white,
                                  fontSize: 10,
                                  font: cairoFont,
                                ),
                              ),
                              padding: pw.EdgeInsets.all(8.0),
                              decoration:
                                  pw.BoxDecoration(color: PdfColors.blue),
                            ),
                        ],
                      ),
                      for (final row in currentPageData)
                        pw.TableRow(
                          children: [
                            for (int i = 0; i < row.length; i++)
                              pw.Container(
                                alignment: i == 5
                                    ? pw.Alignment.centerRight
                                    : pw.Alignment.center,
                                child: i == 3
                                    ? pw.Directionality(
                                        textDirection: pw.TextDirection.rtl,
                                        child: pw.Text(
                                          row[i],
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal,
                                            font: cairoFont,
                                            fontSize: 10.0,
                                          ),
                                          softWrap: true,
                                        ),
                                      )
                                    : pw.Text(
                                        row[i],
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.normal,
                                          font: cairoFont,
                                          fontSize: 10.0,
                                        ),
                                        softWrap: true,
                                      ),
                                padding: pw.EdgeInsets.all(8.0),
                              ),
                          ],
                        ),
                      pw.TableRow(
                        children: List.generate(
                          headers.length, // Number of columns in your table
                          (index) => index == 4
                              ? pw.Container(
                                  padding: pw.EdgeInsets.all(8.0),
                                  alignment: pw.Alignment.center,
                                  child: pw.Text("Total"),
                                )
                              : index == 5
                                  ? pw.Row(
                                      children: [
                                        pw.Container(
                                          padding: pw.EdgeInsets.only(
                                              top: 7.0, left: 6.0),
                                          child: pw.Text(
                                              "${t1.toStringAsFixed(2)}",
                                              style:
                                                  pw.TextStyle(fontSize: 10.0)),
                                        ),
                                      ],
                                    )
                                  : pw.Container(
                                      padding: pw.EdgeInsets.only(
                                          top: 7.0, left: 6.0),
                                      child: pw.Text(""),
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Row(
                  children: [
                    pw.Container(
                      margin: pw.EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 1.20,
                      ),
                      child: pw.Text(
                        'Printed By: ${widget.username}',
                        style: pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Container(
                      margin: pw.EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 1.20,
                        left: MediaQuery.of(context).size.width * 0.25,
                      ),
                      child: pw.Text(
                        '${pageIndex + 1} / $totalPages',
                        style: pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Container(
                      margin: pw.EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 1.20,
                        left: MediaQuery.of(context).size.width * 0.15,
                      ),
                      child: pw.Text(
                        'Print Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}: ',
                        style: pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Container(
                      margin: pw.EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 1.20,
                      ),
                      child: pw.Text(
                        '${DateFormat('HH:mm').format(DateTime.now())}',
                        style: pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String filePath = '$tempPath/Visa_Report.pdf';
    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    OpenFile.open(filePath, type: 'application/pdf');
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VISA Report',
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
                    controller: TextEditingController(text: textStartDate),
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
                    controller: TextEditingController(text: textEndDate),
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
                      labelText: 'End Date',
                    ),
                    onTap: () => _selectEndDate(context),
                  ),
                ),

                ///////////////////////////////////////////////////////////////////

                Container(
                  margin: EdgeInsets.only(
                      top: isPortrait
                          ? MediaQuery.of(context).size.height / 5.4
                          : MediaQuery.of(context).size.height / 3.7),
                  child: Text("Select Branch:"),
                ),

                ///////////////////////////////////////////////////////////////////
                Container(
                  width: MediaQuery.of(context).size.width / 2.6,
                  margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 4.5
                        : MediaQuery.of(context).size.height / 3.0,
                  ),
                  child: SearchField(
                    suggestionStyle:
                        TextStyle(color: Colors.white, fontSize: 18.0),
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
                          VisaReportTable(id_branch: "0");
                        } else {
                          branches = value;
                          branch_ID = branchNameToBrSeqMap[branches];
                          VisaReportTable(id_branch: branch_ID);
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

                Container(
                  width: MediaQuery.of(context).size.width / 1.12,
                  margin: EdgeInsets.only(
                      top: isPortrait
                          ? MediaQuery.of(context).size.height / 3.0
                          : MediaQuery.of(context).size.height / 1.6),
                  child: TextField(
                    onChanged: (value) => _runSearch(value),
                    decoration: InputDecoration(
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

                ////////////////////////////////////////////////////////////////////////////////
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
                    VisaTable(
                      data: foundPatients,
                      t1: t1,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff1f63b6),
        onPressed: () => _downloadAsPDF(context),
        child: const Icon(
          Icons.picture_as_pdf,
          color: Colors.white,
        ),
      ),
    );
  }
}
