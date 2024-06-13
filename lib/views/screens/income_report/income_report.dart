import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:searchfield/searchfield.dart';
import '../../../API_connect/API_connect.dart';
import '../../../widgets/income_table.dart';
import 'package:open_file/open_file.dart';

class IncomeReport extends StatefulWidget {
  final String username;
  final String branch_id;
  final String user_id;
  const IncomeReport(
      {super.key,
      required this.username,
      required this.branch_id,
      required this.user_id});

  @override
  State<IncomeReport> createState() => _IncomeReportState();
}

class _IncomeReportState extends State<IncomeReport> {
  final List<List<String>> tableData = [];
  List<List<String>> foundPatients = [];
  late String textStartDate = '';
  late String textEndDate = '';
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;
  var responseData;
  TextEditingController branchFeild = TextEditingController();
  List<Map<String, dynamic>> listOfMaps = [];
  List<Map<String, dynamic>> listOfMaps2 = [];
  double t1 = 0;
  double t2 = 0;
  double t3 = 0;
  double t4 = 0;
  double t5 = 0;
  double t6 = 0;
  double t7 = 0;
  double t8 = 0;

  String branches = '';
  String branch_ID = '';

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

  void _runSearch(String enteredKeyword) {
    List<List<String>> results = [];

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

  Map<String, dynamic> branchNameToBrSeqMap = {};
  void getBr_seq() {
    for (var data in listOfMaps2) {
      final branchName = data['BranchName'] as String;
      final brSeq = data['Br_Seq'].toString();
      branchNameToBrSeqMap[branchName] = brSeq;
    }
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
        IncomeReportTable();
        // if (branch_ID.isEmpty) {
        //   IncomeReportTable('0');
        // } else {
        //   IncomeReportTable(branch_ID);
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
        IncomeReportTable();
        // if (branch_ID.isEmpty) {
        //   IncomeReportTable('0');
        // } else {
        //   IncomeReportTable(branch_ID);
        // }
      });
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

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('IncomeList') &&
        apiResponse['IncomeList'] is List) {
      List<dynamic> data = apiResponse['IncomeList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }

  Future<void> _fetchTodaysData(String id_branch) async {
    final formatter = DateFormat('yyyy-MM-dd');
    final now = DateTime.now();
    final todayData = formatter.format(now);
    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/IncomeReport",
      data: {
        "startDate": "$todayData",
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
        DateTime vism_date =
            DateFormat('M/d/yyyy h:mm:ss a').parse(row['vism_date']);
        tableData.add([
          row['vism_seq'].toString(),
          row['Br_Code'],
          DateFormat('yyy-MM-dd').format(vism_date),
          stripMargin(row['patname']),
          row['doc_name'],
          row['ins_name'],
          row['total'].toString(),
          row['CDisc'].toString(),
          row['pShare'].toString(),
          row['Pdisc'].toString(),
          row['income'].toString(),
          row['paid'].toString(),
          row['cClaim'].toString(),
          row['remain'].toString(),
        ]);
      });

      foundPatients = tableData;
    });

    double total1 = 0.0;
    double total2 = 0.0;
    double total3 = 0.0;
    double total4 = 0.0;
    double total5 = 0.0;
    double total6 = 0.0;
    double total7 = 0.0;
    double total8 = 0.0;

    if (tableData.isEmpty) {
      t1 = 0.0;
      t2 = 0.0;
      t3 = 0.0;
      t4 = 0.0;
      t5 = 0.0;
      t6 = 0.0;
      t7 = 0.0;
      t8 = 0.0;
    } else {
      for (int i = 0; i < tableData.length; i++) {
        total1 = total1 + double.parse(tableData[i][6]);
        t1 = total1;
        total2 = total2 + double.parse(tableData[i][7]);
        t2 = total2;
        total3 = total3 + double.parse(tableData[i][8]);
        t3 = total3;
        total4 = total4 + double.parse(tableData[i][9]);
        t4 = total4;
        total5 = total5 + double.parse(tableData[i][10]);
        t5 = total5;
        total6 = total6 + double.parse(tableData[i][11]);
        t6 = total6;
        total7 = total7 + double.parse(tableData[i][12]);
        t7 = total7;
        total8 = total8 + double.parse(tableData[i][13]);
        t8 = total8;
      }
    }
  }

  Future<void> IncomeReportTable({String id_branch = "0"}) async {
    try {
      if (startDate != null) {
        setState(() {
          isLoading = true;
        });
        showDialog(
          context: context,
          barrierDismissible: false,
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
          endpoint: "/api/IncomeReport",
          data: {
            "startDate": "$startDateString",
            "endDate": "$endDateString",
            "BranchID": "${id_branch}",
            "UserID": "${widget.user_id}"
          },
        );
        Map<String, dynamic> ApiResponse = responseData;

        listOfMaps = convertApiResponseToList(ApiResponse);

        setState(() {
          tableData.clear();
          listOfMaps.forEach((row) {
            DateTime vism_date =
                DateFormat('M/d/yyyy h:mm:ss a').parse(row['vism_date']);
            tableData.add([
              row['vism_seq'].toString(),
              row['Br_Code'],
              DateFormat('yyy-MM-dd').format(vism_date),
              stripMargin(row['patname']),
              row['doc_name'],
              row['ins_name'],
              row['total'].toString(),
              row['CDisc'].toString(),
              row['pShare'].toString(),
              row['Pdisc'].toString(),
              row['income'].toString(),
              row['paid'].toString(),
              row['cClaim'].toString(),
              row['remain'].toString(),
            ]);
          });
          isLoading = false;
          Navigator.of(context).pop();
          foundPatients = tableData;
        });

        double total1 = 0.0;
        double total2 = 0.0;
        double total3 = 0.0;
        double total4 = 0.0;
        double total5 = 0.0;
        double total6 = 0.0;
        double total7 = 0.0;
        double total8 = 0.0;

        if (tableData.isEmpty) {
          t1 = 0.0;
          t2 = 0.0;
          t3 = 0.0;
          t4 = 0.0;
          t5 = 0.0;
          t6 = 0.0;
          t7 = 0.0;
          t8 = 0.0;
        } else {
          for (int i = 0; i < tableData.length; i++) {
            total1 = total1 + double.parse(tableData[i][6]);
            t1 = total1;
            total2 = total2 + double.parse(tableData[i][7]);
            t2 = total2;
            total3 = total3 + double.parse(tableData[i][8]);
            t3 = total3;
            total4 = total4 + double.parse(tableData[i][9]);
            t4 = total4;
            total5 = total5 + double.parse(tableData[i][10]);
            t5 = total5;
            total6 = total6 + double.parse(tableData[i][11]);
            t6 = total6;
            total7 = total7 + double.parse(tableData[i][12]);
            t7 = total7;
            total8 = total8 + double.parse(tableData[i][13]);
            t8 = total8;
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
          endpoint: "/api/IncomeReport",
          data: {
            "startDate": "$startDateString",
            "endDate": "$endDateString",
            "BranchID": "${id_branch}",
            "UserID": "${widget.user_id}"
          },
        );
        Map<String, dynamic> ApiResponse = responseData;

        listOfMaps = convertApiResponseToList(ApiResponse);

        setState(() {
          tableData.clear();
          listOfMaps.forEach((row) {
            DateTime vism_date =
                DateFormat('M/d/yyyy h:mm:ss a').parse(row['vism_date']);
            tableData.add([
              row['vism_seq'].toString(),
              row['Br_Code'],
              DateFormat('yyy-MM-dd').format(vism_date),
              stripMargin(row['patname']),
              row['doc_name'],
              row['ins_name'],
              row['total'].toString(),
              row['CDisc'].toString(),
              row['pShare'].toString(),
              row['Pdisc'].toString(),
              row['income'].toString(),
              row['paid'].toString(),
              row['cClaim'].toString(),
              row['remain'].toString(),
            ]);
          });
          isLoading = false;
          Navigator.of(context).pop();
          foundPatients = tableData;
        });
        double total1 = 0.0;
        double total2 = 0.0;
        double total3 = 0.0;
        double total4 = 0.0;
        double total5 = 0.0;
        double total6 = 0.0;
        double total7 = 0.0;
        double total8 = 0.0;

        if (tableData.isEmpty) {
          t1 = 0.0;
          t2 = 0.0;
          t3 = 0.0;
          t4 = 0.0;
          t5 = 0.0;
          t6 = 0.0;
          t7 = 0.0;
          t8 = 0.0;
        } else {
          for (int i = 0; i < tableData.length; i++) {
            total1 = total1 + double.parse(tableData[i][6]);
            t1 = total1;
            total2 = total2 + double.parse(tableData[i][7]);
            t2 = total2;
            total3 = total3 + double.parse(tableData[i][8]);
            t3 = total3;
            total4 = total4 + double.parse(tableData[i][9]);
            t4 = total4;
            total5 = total5 + double.parse(tableData[i][10]);
            t5 = total5;
            total6 = total6 + double.parse(tableData[i][11]);
            t6 = total6;
            total7 = total7 + double.parse(tableData[i][12]);
            t7 = total7;
            total8 = total8 + double.parse(tableData[i][13]);
            t8 = total8;
          }
        }
      }
    } catch (e) {
      log("$e");
    }
  }

  Future<void> _downloadAsPDF(BuildContext context) async {
    final pdf = pw.Document();

    final headers = [
      'vism_seq',
      'Br_Code',
      'vism_date',
      'Patient Name',
      'Doctor Name',
      'ins_name',
      'total',
      'CDisc',
      'pShare',
      'Pdisc',
      'income',
      'paid',
      'cClaim',
      'remain'
    ];

    final cairoFontData = await rootBundle.load('fonts/Amiri-Regular.ttf');
    final cairoFont = pw.Font.ttf(cairoFontData);

    final rowsPerPage = 26; // Number of rows to display per page
    final totalRows = tableData.length;
    final totalPages = (totalRows / rowsPerPage).ceil();

    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      final startRow = pageIndex * rowsPerPage;
      final endRow = (pageIndex + 1) * rowsPerPage;
      final currentPageData =
          tableData.sublist(startRow, endRow < totalRows ? endRow : totalRows);

      bool isLastPage = pageIndex == (totalPages - 1);

      final table = isLastPage
          ? pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.grey,
                width: 0.5,
              ),
              columnWidths: {
                // Define the column widths of the table
                for (int i = 0; i < headers.length; i++)
                  if (i == 5)
                    i: pw.FixedColumnWidth(100)
                  else if (i == 0)
                    i: pw.FixedColumnWidth(48)
                  else if (i == 3)
                    i: pw.FixedColumnWidth(80)
                  else if (i == 4)
                    i: pw.FixedColumnWidth(90)
                  else if (i == 1)
                    i: pw.FixedColumnWidth(48)
                  else if (i == 2)
                    i: pw.FixedColumnWidth(50)
                  else if (i == 6)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 7)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 8)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 9)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 10)
                    i: pw.FixedColumnWidth(39)
                  else if (i == 11)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 12)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 13)
                    i: pw.FixedColumnWidth(38)
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
                            fontSize: 8,
                            font: cairoFont,
                          ),
                        ),
                        padding: pw.EdgeInsets.all(8.0),
                        decoration: pw.BoxDecoration(color: PdfColors.blue),
                      ),
                  ],
                ),
                for (final row in currentPageData)
                  pw.TableRow(
                    children: [
                      for (int i = 0; i < row.length; i++)
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: i == 3 || i == 4 || i == 5
                              ? pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    row[i],
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      font: cairoFont,
                                      fontSize: 8,
                                    ),
                                    softWrap: true,
                                  ),
                                )
                              : pw.Text(
                                  row[i],
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal,
                                    font: cairoFont,
                                    fontSize: 8,
                                  ),
                                  softWrap: true,
                                ),
                          padding: pw.EdgeInsets.all(4.0),
                        ),
                    ],
                  ),
                pw.TableRow(
                  children: List.generate(
                    headers.length, // Number of columns in your table
                    (index) => index == 5
                        ? pw.Container(
                            padding: pw.EdgeInsets.all(8.0),
                            alignment: pw.Alignment.center,
                            child: pw.Text("Total"),
                          )
                        : index == 6
                            ? pw.Row(
                                children: [
                                  pw.Container(
                                    // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                    child: pw.Text(
                                      "${t1.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)
                                    ),
                                  ),
                                ],
                              )
                            : index == 7
                                ? pw.Row(
                                    children: [
                                      pw.Container(
                                         // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                        child: pw.Text("${t2.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                      ),
                                    ],
                                  )
                                : index == 8
                                    ? pw.Row(
                                        children: [
                                          pw.Container(
                                           // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                            child: pw.Text("${t3.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                          ),
                                        ],
                                      )
                                    : index == 9
                                        ? pw.Row(
                                            children: [
                                              pw.Container(
                                                  // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                child: pw.Text("${t4.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                              ),
                                            ],
                                          )
                                        : index == 10
                                            ? pw.Row(
                                                children: [
                                                  pw.Container(
                                                     // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                    child: pw.Text("${t5.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                                  ),
                                                ],
                                              )
                                            : index == 11
                                                ? pw.Row(
                                                    children: [
                                                      pw.Container(
                                                        // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                        child: pw.Text("${t6.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                                      ),
                                                    ],
                                                  )
                                                : index == 12
                                                    ? pw.Row(
                                                        children: [
                                                          pw.Container(
                                                             // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                            child:
                                                                pw.Text("${t7.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                                          ),
                                                        ],
                                                      )
                                                    : index == 13
                                                        ? pw.Row(
                                                            children: [
                                                              pw.Container(
                                                                 // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                                child: pw.Text(
                                                                    "${t8.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                                              ),
                                                            ],
                                                          )
                                                        : pw.Container(
                                                             // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                            child: pw.Text(""),
                                                          ),
                  ),
                ),
              ],
            )
          : pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.grey,
                width: 0.5,
              ),
              columnWidths: {
                // Define the column widths of the table
                for (int i = 0; i < headers.length; i++)
                  if (i == 5)
                    i: pw.FixedColumnWidth(100)
                  else if (i == 0)
                    i: pw.FixedColumnWidth(48)
                  else if (i == 3)
                    i: pw.FixedColumnWidth(80)
                  else if (i == 4)
                    i: pw.FixedColumnWidth(90)
                  else if (i == 1)
                    i: pw.FixedColumnWidth(48)
                  else if (i == 2)
                    i: pw.FixedColumnWidth(50)
                  else if (i == 6)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 7)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 8)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 9)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 10)
                    i: pw.FixedColumnWidth(39)
                  else if (i == 11)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 12)
                    i: pw.FixedColumnWidth(38)
                  else if (i == 13)
                    i: pw.FixedColumnWidth(38)
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
                            fontSize: 8,
                            font: cairoFont,
                          ),
                        ),
                        padding: pw.EdgeInsets.all(8.0),
                        decoration: pw.BoxDecoration(color: PdfColors.blue),
                      ),
                  ],
                ),
                for (final row in currentPageData)
                  pw.TableRow(
                    children: [
                      for (int i = 0; i < row.length; i++)
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: i == 3 || i == 4 || i == 5
                              ? pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    row[i],
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.normal,
                                      font: cairoFont,
                                      fontSize: 8,
                                    ),
                                    softWrap: true,
                                  ),
                                )
                              : pw.Text(
                                  row[i],
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.normal,
                                    font: cairoFont,
                                    fontSize: 8,
                                  ),
                                  softWrap: true,
                                ),
                          padding: pw.EdgeInsets.all(4.0),
                        ),
                    ],
                  ),
                pw.TableRow(
                  children: List.generate(
                    headers.length, // Number of columns in your table
                    (index) => index == 5
                        ? pw.Container(
                            padding: pw.EdgeInsets.all(8.0),
                            alignment: pw.Alignment.center,
                            child: pw.Text("Total"),
                          )
                        : index == 6
                            ? pw.Row(
                                children: [
                                  pw.Container(
                                     // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                    child: pw.Text(
                                      "${t1.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0),
                                    ),
                                  ),
                                ],
                              )
                            : index == 7
                                ? pw.Row(
                                    children: [
                                      pw.Container(
                                         // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                        child: pw.Text("${t2.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                      ),
                                    ],
                                  )
                                : index == 8
                                    ? pw.Row(
                                        children: [
                                          pw.Container(
                                             // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                            child: pw.Text("${t3.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                          ),
                                        ],
                                      )
                                    : index == 9
                                        ? pw.Row(
                                            children: [
                                              pw.Container(
                                                 // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                child: pw.Text("${t4.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                              ),
                                            ],
                                          )
                                        : index == 10
                                            ? pw.Row(
                                                children: [
                                                  pw.Container(
                                                    // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                    child: pw.Text("${t5.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                                  ),
                                                ],
                                              )
                                            : index == 11
                                                ? pw.Row(
                                                    children: [
                                                      pw.Container(
                                                         // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                        child: pw.Text("${t6.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                                      ),
                                                    ],
                                                  )
                                                : index == 12
                                                    ? pw.Row(
                                                        children: [
                                                          pw.Container(
                                                             // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                            child:
                                                                pw.Text("${t7.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                                          ),
                                                        ],
                                                      )
                                                    : index == 13
                                                        ? pw.Row(
                                                            children: [
                                                              pw.Container(
                                                                 // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                                child: pw.Text(
                                                                    "${t8.toStringAsFixed(2)}",
                                      style: pw.TextStyle(fontSize: 10.0)),
                                                              ),
                                                            ],
                                                          )
                                                        : pw.Container(
                                                              // margin: pw.EdgeInsets.only(
                                    //     left:
                                    //         MediaQuery.of(context).size.width /
                                    //             20.0),
                                    padding: pw.EdgeInsets.only(top:7.0,left:6.0),
                                                            child: pw.Text(""),
                                                          ),
                  ),
                ),
              ],
            );

      final pdfWidget = isLastPage
          ? pw.Stack(
              children: [
                pw.Container(
                  child: pw.Container(
                    margin: pw.EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 1.60),
                    child: pw.Text(
                      "Income Report",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 8.7,
                      left: MediaQuery.of(context).size.width / 0.78),
                  child: pw.Text(
                    'Period: $textStartDate   -   $textEndDate',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),

                ////////////////////////////Table////////////////////////////////
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 1.0,
                      top: MediaQuery.of(context).size.height / 7.0
                      // top: MediaQuery.of(context).size.height * 0.08,
                      ),
                  child: pw.Transform.rotate(
                    angle: 0,
                    child: pw.Flex(
                      direction: pw.Axis.horizontal,
                      children: [table],
                    ),
                  ),
                ),
                ///////////////////////////////////////////////////////////////
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 0.8),
                  child: pw.Text(
                    'Printed By: ${widget.username}',
                    style: pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 0.8,
                      left: MediaQuery.of(context).size.width / 1.20),
                  child: pw.Text(
                    '${pageIndex + 1} / $totalPages',
                    style: pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 0.8,
                      left: MediaQuery.of(context).size.width / 0.78),
                  child: pw.Text(
                    'Print Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}: ',
                    style: pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 0.8,
                      left: MediaQuery.of(context).size.width / 0.6),
                  child: pw.Text(
                    '${DateFormat('HH:mm').format(DateTime.now())}',
                    style: pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            )
          : pw.Stack(
              children: [
                pw.Container(
                  child: pw.Container(
                    margin: pw.EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 1.60),
                    child: pw.Text(
                      "Income Report",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 8.7,
                      left: MediaQuery.of(context).size.width / 0.78),
                  child: pw.Text(
                    'Period: $textStartDate   -   $textEndDate',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 1.0,
                      top: MediaQuery.of(context).size.height / 7.0
                      // top: MediaQuery.of(context).size.height * 0.08,
                      ),
                  child: pw.Transform.rotate(
                    angle: 0,
                    child: pw.Flex(
                      direction: pw.Axis.horizontal,
                      children: [table],
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 0.8),
                  child: pw.Text(
                    'Printed By: ${widget.username}',
                    style: pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 0.8,
                      left: MediaQuery.of(context).size.width / 1.20),
                  child: pw.Text(
                    '${pageIndex + 1} / $totalPages',
                    style: pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 0.8,
                      left: MediaQuery.of(context).size.width / 0.78),
                  child: pw.Text(
                    'Print Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}: ',
                    style: pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 0.8,
                      left: MediaQuery.of(context).size.width / 0.6),
                  child: pw.Text(
                    '${DateFormat('HH:mm').format(DateTime.now())}',
                    style: pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a3,
          orientation: pw.PageOrientation.portrait,
          build: (pw.Context context) {
            return pw.Container(
              child: pdfWidget,
            );
          },
        ),
      );
    }

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/Income_Report.pdf';

    // Save the PDF file
    final file = File(filePath);
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
          'Income Report',
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
                    controller: branchFeild,
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
                          IncomeReportTable(id_branch: "0");
                        } else {
                          branches = value;
                          branch_ID = branchNameToBrSeqMap[branches];
                          IncomeReportTable(id_branch: branch_ID);
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
                    IncomeTable(
                      data: foundPatients,
                      t1: t1,
                      t2: t2,
                      t3: t3,
                      t4: t4,
                      t5: t5,
                      t6: t6,
                      t7: t7,
                      t8: t8,
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
