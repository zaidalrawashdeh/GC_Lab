import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import '../../../API_Update/API_update.dart';
import '../../../widgets/ResultEntry_table.dart';
import 'package:diagnostic/global_variable/globals.dart' as globals;

class ResultEntry extends StatefulWidget {
  final String patientName;
  final String sampleNo;
  final String buttonID;
  final String username;
  const ResultEntry(
      {super.key,
      required this.patientName,
      required this.sampleNo,
      required this.buttonID,
      required this.username});

  @override
  State<ResultEntry> createState() => _ResultEntryState();
}

class _ResultEntryState extends State<ResultEntry> {
  bool isLoading = true;

  Future<void> approveAllSamples() async {
    final formatter = DateFormat('yyy-dd-MM HH:mm');
    final now = DateTime.now();
    final nowDate = formatter.format(now);

    try {
      await APIUpdate.updateResultEntry(
        endpoint: "/api/ApproveAllSingleTest",
        data: {
          "results2": [
            {
              "UserName": "${widget.username}",
              "Date": "$nowDate",
              "Vism_Seq": "${globals.sample}",
              "ButtonID": "${widget.buttonID}",
              "Approve": "1"
            }
          ]
        },
      );
      // var dio = Dio();

      // await dio.request(
      //   'http://62.171.174.119:125/api/ApproveAllSingleTest',
      //   options: Options(
      //     method: 'POST',
      //   ),
      //   data: {
      //     "results2": [
      //       {
      //         "UserName": "${widget.username}",
      //         "Date": "$nowDate",
      //         "Vism_Seq": "${globals.sample}",
      //         "ButtonID": "${widget.buttonID}"
      //       }
      //     ]
      //   },
      // );
    } catch (e) {
      log("$e");
    }
  }

  Future<void> UnapproveAllSamples() async {
    final formatter = DateFormat('yyy-dd-MM HH:mm');
    final now = DateTime.now();
    final nowDate = formatter.format(now);

    try {
      await APIUpdate.updateResultEntry(
        endpoint: "/api/ApproveAllSingleTest",
        data: {
          "results2": [
            {
              "UserName": "${widget.username}",
              "Date": "$nowDate",
              "Vism_Seq": "${globals.sample}",
              "ButtonID": "${widget.buttonID}",
              "Approve": "0"
            }
          ]
        },
      );
    } catch (e) {
      log("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Result Entry',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 35,
                left: MediaQuery.of(context).size.height / 50,
              ),
              child: RichText(
                text: TextSpan(
                  text: 'Patient Name:  ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: widget.patientName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ////////////////////////////////////////////////////////////////
            Container(
              margin: EdgeInsets.only(
                top: isPortrait
                    ? MediaQuery.of(context).size.height / 15
                    : MediaQuery.of(context).size.height / 9.0,
                left: MediaQuery.of(context).size.height / 50,
              ),
              child: RichText(
                text: TextSpan(
                  text: 'Sample No:  ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: widget.sampleNo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),

/////////////////// Approve all Button /////////////////////////////////////
            Container(
              margin: EdgeInsets.only(
                top: isPortrait
                    ? MediaQuery.of(context).size.height / 10.0
                    : MediaQuery.of(context).size.height / 5.7,
                left: MediaQuery.of(context).size.height / 60,
              ),
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  clipBehavior: Clip.none,
                  onPressed: () {
                    setState(() {
                      log("${globals.ConfirmResults}");
                      if (globals.ConfirmResults == 'False') {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  "Approve not allowed",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.0),
                                ),
                              );
                            });
                        // Future.delayed(Duration(seconds: 2),(){
                        //   Navigator.of(context).pop();
                        // });
                      } else {
                        approveAllSamples().then((value) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content: Text(
                                  "All Samples Approved ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                backgroundColor: Color(0xff1f63b6),
                              );
                            },
                          );
                        });
                        // Future.delayed(Duration(seconds: 3), () {
                        //   Navigator.of(context).pop();
                        // });
                      }
                    });
                  },
                  child: Text(
                    "Approve all",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  )),
            ),

            //////////////////////// UnApprove all Button ////////////////////////////////
            Container(
              margin: EdgeInsets.only(
                top: isPortrait
                    ? MediaQuery.of(context).size.height / 10.0
                    : MediaQuery.of(context).size.height / 5.7,
                left: isPortrait
                    ? MediaQuery.of(context).size.height / 5.7
                    : MediaQuery.of(context).size.height / 3,
              ),
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)))),
                  clipBehavior: Clip.none,
                  onPressed: () {
                    setState(() {
                      if (globals.ConfirmResults == 'False') {
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
                        // Future.delayed(Duration(seconds: 2),(){
                        //   Navigator.of(context).pop();
                        // });
                      } else {
                        UnapproveAllSamples().then((value) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content: Text(
                                  "All Samples UnApproved ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                backgroundColor: Color(0xff1f63b6),
                              );
                            },
                          );
                        });
                        // Future.delayed(Duration(seconds: 3), () {
                        //   Navigator.of(context).pop();
                        // });
                      }
                    });
                  },
                  child: Text(
                    "UnApprove all",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  )),
            ),

            ////////////
            Container(
              margin: EdgeInsets.only(
                top: isPortrait
                    ? MediaQuery.of(context).size.height / 5.0
                    : MediaQuery.of(context).size.height / 2.8,
              ),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ResultEntryTable(
                    username: widget.username,
                    buttonId: widget.buttonID,
                  )),
            ),

            ///////////////
          ],
        ),
      ),
      persistentFooterButtons: [
        Container(
          color: Color(0xff1f63b6),
          child: Center(
            child: TextButton(
              onPressed: () async {
                try {
                  for (var tableData in globals.pat_table_data) {
                    await APIUpdate.updateResultEntry(
                      endpoint: "/api/ResultsEntry",
                      data: {
                        "results4": [
                          {
                            "Result": "${tableData[2]}",
                            "VisS_VisM_no": "${tableData[4]}",
                            "VisS_sub_Seq": "${tableData[5]}"
                          }
                        ]
                      },
                    );
                    //             var dio = Dio();

                    // await dio.request(
                    //   'http://62.171.174.119:125/api/ResultsEntry',
                    //   options: Options(
                    //     method: 'POST',
                    //   ),
                    //   data: {
                    //     "results4": [
                    //       {
                    //         "Result": "${tableData[2]}",
                    //         "VisS_VisM_no": "${tableData[4]}",
                    //         "VisS_sub_Seq": "${tableData[5]}"

                    //       }
                    //     ]
                    //   },
                    // );
                  }
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Center(
                              child: Text(
                            "Save Data",
                            style: TextStyle(color: Colors.white),
                          )),
                          content: Text(
                            "Data saved successfully",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          backgroundColor: Color(0xff1f63b6),
                        );
                      });
                  // Future.delayed(Duration(seconds: 3), () {
                  //   Navigator.of(context).pop();
                  // });
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Center(
                              child: Text(
                            "Problem",
                            style: TextStyle(color: Colors.white),
                          )),
                          content: Text(
                            "Data not saved successfully",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          backgroundColor: Color(0xff1f63b6),
                        );
                      });
                  log("$e");
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
