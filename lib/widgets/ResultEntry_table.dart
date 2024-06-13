import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:diagnostic/global_variable/globals.dart' as globals;
import 'dart:convert';
import '../API_Update/API_update.dart';
import '../API_connect/API_connect.dart';

class ResultEntryTable extends StatefulWidget {
  final String buttonId;
  final String username;
  const ResultEntryTable(
      {super.key, required this.buttonId, required this.username});

  @override
  State<ResultEntryTable> createState() => _ResultEntryTableState();
}

class _ResultEntryTableState extends State<ResultEntryTable> {
  List<bool> isCheckedList = [];
  List<String> x = [];
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];

  @override
  void initState() {
    globals.pat_table_data.clear();
    Future.delayed(Duration(seconds: 1), () {
      patientTable();
    });

    super.initState();
  }

  ScrollController _scrollController = ScrollController();

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('AllTestsList') &&
        apiResponse['AllTestsList'] is List) {
      List<dynamic> data = apiResponse['AllTestsList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }

// Update VisS_Result Data
  Future<void> _UpdateVisS_ResultData(String val, List<String> rowData) async {
    int index = globals.pat_table_data.indexOf(rowData);

    globals.pat_table_data[index][2] = val;

    setState(() {
      val;
    });
  }

  Future<void> _UnApproveButton(
      String VisS_Test_Seq, String VisS_sub_Seq) async {
    final formatter = DateFormat('yyy-dd-MM HH:mm');
    final now = DateTime.now();
    final nowDate = formatter.format(now);
    if (int.parse(widget.buttonId) <= 4) {
      try {
        await APIUpdate.updateResultEntry(
          endpoint: "/api/ApproveSingleTest",
          data: {
            "results3": [
              {
                "UserName": "${widget.username}",
                "Date": "$nowDate",
                "Vism_Seq": "${globals.sample}",
                "VisS_Test_Seq": "${VisS_Test_Seq}",
                "VisS_sub_Seq": "${VisS_sub_Seq}",
                "Approve": "0"
              }
            ]
          },
        );
      } catch (e) {
        log("$e");
      }
    }
  }

  // Update Table Data

  Future<void> _UpdateTableData(
      String VisS_Test_Seq, String VisS_sub_Seq) async {
    final formatter = DateFormat('yyy-dd-MM HH:mm');
    final now = DateTime.now();
    final nowDate = formatter.format(now);
    if (int.parse(widget.buttonId) <= 4) {
      try {
        await APIUpdate.updateResultEntry(
          endpoint: "/api/ApproveSingleTest",
          data: {
            "results3": [
              {
                "UserName": "${widget.username}",
                "Date": "$nowDate",
                "Vism_Seq": "${globals.sample}",
                "VisS_Test_Seq": "${VisS_Test_Seq}",
                "VisS_sub_Seq": "${VisS_sub_Seq}",
                "Approve": "1"
              }
            ]
          },
        );
        // var dio = Dio();

        // await dio.request(
        //   'http://62.171.174.119:125/api/ApproveSingleTest',
        //   options: Options(
        //     method: 'POST',
        //   ),
        //   data: {
        //     "results3": [
        //       {
        //         "UserName": "${widget.username}",
        //         "Date": "$nowDate",
        //         "Vism_Seq": "${globals.sample}",
        //         "VisS_Test_Seq": "${VisS_Test_Seq}",
        //         "VisS_sub_Seq": "${VisS_sub_Seq}"
        //       }
        //     ]
        //   },
        // );
      } catch (e) {
        log("$e");
      }
    }
  }

//Split String by Newline Using LineSplitter
  String stripMargin(var s) {
    String z = "";
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(s.toString());

    for (var i = 0; i < lines.length; i++) {
      z += lines[i].trim();
    }

    return z;
  }

// Fetch Data From Database
  Future<void> patientTable() async {
    try {
      responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/AllTests",
        data: {
          "VisM_Seq": "${globals.sample}",
          "buttonID": "${widget.buttonId}"
        },
      );
      Map<String, dynamic> ApiResponse = responseData;

      listOfMaps = convertApiResponseToList(ApiResponse);

      setState(() {
        globals.pat_table_data.clear();
        listOfMaps.forEach((row) {
          globals.pat_table_data.add([
            row['Test_Code'].toString(),
            row['Test_Name'].toString(),
            row['VisS_Result'].toString(),
            row['Nor_Conventional'].toString(),
            row['VisS_VisM_no'].toString(),
            row['VisS_sub_Seq'].toString(),
            row['VisS_ConfirmResult'].toString(),
            row['VisS_Test_Seq'].toString(),
          ]);
        });
      });
      log("${globals.pat_table_data}");
    } catch (e) {
      log("$e");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTableHeader(),
          Container(
            height: screenSize.height * 0.8,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Table(
                border: TableBorder.all(
                  width: 0.5,
                  color: Color.fromARGB(255, 112, 107, 107),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FixedColumnWidth(screenSize.width * 0.40), // Test_Code
                  1: FixedColumnWidth(screenSize.width * 0.40), // Test_Name
                  2: FixedColumnWidth(screenSize.width * 0.40), // VisS_Result
                  3: FixedColumnWidth(
                      screenSize.width * 0.40), // Nor_Conventional
                  4: FixedColumnWidth(screenSize.width * 0.47),
                },
                children: [
                  for (List<String> rowData in globals.pat_table_data)
                    _buildTableRow(rowData),
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
          _buildTableHeaderCell('Test_Code', 0),
          _buildTableHeaderCell('Test_Name', 1),
          _buildTableHeaderCell('VisS_Result', 2),
          _buildTableHeaderCell('Nor_Conventional', 3),
          _buildTableHeaderCell('Approve', 3),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text, int columnIndex) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      // margin: EdgeInsets.only(right: 30.0),
      width: screenSize.width * 0.413,
      padding: EdgeInsets.all(8.0),
      // alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> rowData) {
    int index = globals.pat_table_data.indexOf(rowData);
    globals.VisS_Result_data = rowData;

    isCheckedList.add(false);
    return TableRow(
      children: [
        _buildTableCell(rowData[0], 0, rowData, index),
        _buildTableCell(rowData[1], 1, rowData, index),
        _buildTableCell(rowData[2], 2, rowData, index),
        _buildTableCell(rowData[3], 3, rowData, index),
        _buildButtonCell(index, rowData),
      ],
    );
  }

  TableCell _buildTableCell(
      String text, int columnIndex, List<String> rowData, int index) {
    TextEditingController controller = TextEditingController();

    if (rowData[6] == 'False') {
      controller.text = globals.pat_table_data[index][columnIndex];
    }
    return TableCell(
      child: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: columnIndex == 2 && rowData[6] == 'False' // VisS_Result column
            ? Container(
                alignment: Alignment.center,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  onSubmitted: (value) async {
                    // Handle the onChanged event
                    _UpdateVisS_ResultData(value, rowData);
                  },
                ),
              )
            : Text(
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

  TableCell _buildButtonCell(int index, List<String> rowData) {
    return int.parse(widget.buttonId) <= 4
        ? TableCell(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          String VisS_Test_Seq = "${rowData[7]}";
                          String VisS_sub_Seq = "${rowData[5]}";
                          setState(() {
                            if (globals.ConfirmResults == 'False'||globals.finalize=="False") {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                        "Approve not allowed",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0),
                                      ),
                                    );
                                  });
                              //  Future.delayed(Duration(seconds: 2),(){
                              //   Navigator.of(context).pop();
                              //  });
                            } else if (globals
                                .pat_table_data[index][2].isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      "The result is Empty",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  );
                                },
                              );

                              // Future.delayed(Duration(seconds: 3), () {
                              //   Navigator.of(context).pop();
                              // });
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: 10.0,
                                    child: AlertDialog(
                                      scrollable: true,
                                      content: Column(
                                        children: [
                                          Text(
                                            "Do you want approve this sample (${globals.pat_table_data[index][0]})?",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0),
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                // Execute No Button
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  //
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            7.0,
                                                    margin: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15.0,
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.7,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              119,
                                                              115,
                                                              115),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                // Execute Yes Button
                                                InkWell(
                                                  onTap: () {
                                                    _UpdateTableData(
                                                            VisS_Test_Seq,
                                                            VisS_sub_Seq)
                                                        .then((value) {
                                                      setState(() {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content: Text(
                                                                  "Sample Approved",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.0),
                                                                ),
                                                              );
                                                            }).then((value) {
                                                          setState(() {
                                                            rowData[6] = 'True';
                                                          });
                                                        });

                                                        // Future.delayed(
                                                        //     Duration(seconds: 3),
                                                        //     () {
                                                        //   Navigator.of(context)
                                                        //       .pop();
                                                        // });
                                                      });
                                                    });
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            7.0,
                                                    margin: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15.0,
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              30.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      color: const Color(
                                                          0xff1f63b6),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                //
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                  );
                                },
                              );
                            }
                          });
                        },
                        child: Text('Approve'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 20.0),
                      child: Checkbox(
                        value: rowData[6] == 'True' ? true : false,
                        onChanged: (value) {
                          log("${rowData[6]}");
                          setState(() {
                            isCheckedList[index] = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                //////////////////////////////  UnApprove Button ////////////////////////////////////////////////
                Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      String VisS_Test_Seq = "${rowData[7]}";
                      String VisS_sub_Seq = "${rowData[5]}";
                      setState(() {
                        if (globals.ConfirmResults == 'False'||globals.finalize=="False") {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(
                                    "UnApprove not allowed",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                  ),
                                );
                              });
                          //  Future.delayed(Duration(seconds: 2),(){
                          //   Navigator.of(context).pop();
                          //  });
                        } else if (globals.pat_table_data[index][2].isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  "The result is Empty",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              );
                            },
                          );

                          // Future.delayed(Duration(seconds: 3), () {
                          //   Navigator.of(context).pop();
                          // });
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 10.0,
                                child: AlertDialog(
                                  scrollable: true,
                                  content: Column(
                                    children: [
                                      Text(
                                        "Do you want UnApprove this sample (${globals.pat_table_data[index][0]})?",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            // Execute No Button
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              //
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    7.0,
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      15.0,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.7,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: const Color.fromARGB(
                                                      255, 119, 115, 115),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Execute Yes Button
                                            InkWell(
                                              onTap: () {
                                                _UnApproveButton(VisS_Test_Seq,
                                                        VisS_sub_Seq)
                                                    .then((value) {
                                                  setState(() {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: Text(
                                                              "Sample UnApproved",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0),
                                                            ),
                                                          );
                                                        }).then((value) {
                                                      setState(() {
                                                        rowData[6] = 'False';
                                                      });
                                                    });
                                                  });
                                                });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    7.0,
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      15.0,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      30.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color:
                                                      const Color(0xff1f63b6),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              );
                            },
                          );
                        }
                      });
                    },
                    child: Text('UnApprove'),
                  ),
                ),
              ]),
            ),
          )
        :
        // else
        TableCell(
            child: Row(
              children: [
                Checkbox(
                  value: rowData[6] == 'True' ? true : false,
                  onChanged: (value) {
                    log("${rowData[6]}");
                    setState(() {
                      isCheckedList[index] = value!;
                    });
                  },
                ),
              ],
            ),
          );
  }
}
