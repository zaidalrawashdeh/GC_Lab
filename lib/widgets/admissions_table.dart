import 'package:flutter/material.dart';
import 'dart:developer';
import '../API_Update/API_update.dart';
import '../API_connect/API_connect.dart';
import '../views/screens/samples/samples.dart';
import 'admissions_class.dart';
import 'package:diagnostic/global_variable/globals.dart' as globals;

class AdmissionsTable extends StatefulWidget {
  final List<results> contacts;
  final String username;
  final String finalize;
  const AdmissionsTable(
      {super.key,
      required this.contacts,
      required this.username,
      required this.finalize});

  @override
  State<AdmissionsTable> createState() => _AdmissionsTableState();
}

class _AdmissionsTableState extends State<AdmissionsTable> {
  final FocusNode _focusNode = FocusNode();
  String hintText = ""; // Initial hint text
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];
  bool? isCheckedList;

  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      if (_focusNode.hasFocus) {
        hintText = ""; // Clear hint text when TextField is focused
      } else {
        hintText = ""; // Restore hint text when TextField loses focus
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  final List<List<String>> tableData = [];
  String discount = '';

  Future<void> _finalizeButton(String Vism_Seq) async {
    try {
      await APIUpdate.updateResultEntry(
        endpoint: "/api/Finalize",
        data: {
          "Vism_Seq": Vism_Seq,
          "Finalize": "1",
        },
      );
    } catch (e) {
      log("$e");
    }
  }

  Future<void> _UnfinalizeButton(String Vism_Seq) async {
    try {
      await APIUpdate.updateResultEntry(
        endpoint: "/api/Finalize",
        data: {
          "Vism_Seq": Vism_Seq,
          "Finalize": "0",
        },
      );
    } catch (e) {
      log("$e");
    }
  }

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('AmountList') &&
        apiResponse['AmountList'] is List) {
      List<dynamic> data = apiResponse['AmountList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }

  // TDA (Total Discount Amount to pay)
  Future<void> FetchTDAdata(int SampleNo) async {
    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Amount",
      data: {"VisM_Seq": "$SampleNo"},
    );
    Map<String, dynamic> ApiResponse = responseData;
    listOfMaps = convertApiResponseToList(ApiResponse);

    tableData.clear();
    listOfMaps.forEach((row) {
      tableData.add([
        row['VisM_Seq'].toString(),
        row['Vism_Total'].toString(),
        row['VisM_Discount'].toString(),
        row['AmountToPay'].toString(),
      ]);
    });
    log("$tableData");
  }

  @override
  Widget build(BuildContext context) {
    // final buttonBackgroundColor =
    //     Color(0xFF1F63B6); // Set the background color for the button

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(
              0xFF1F63B6), // Set the background color for the entire table box
        ),
        child: DataTable(
          dataRowHeight: MediaQuery.of(context).size.height / 6.0,
          border: TableBorder.all(
            color: Colors.grey,
            width: 0.5,
          ),
          headingRowColor: MaterialStateColor.resolveWith((states) =>
              Color(0xff1f63b6)), // Set the background color for the header row
          dataRowColor: MaterialStateColor.resolveWith((states) =>
              Colors.white), // Set the background color for the data rows
          columns: const [
            DataColumn(
              label: Text(
                'Sample No',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataColumn(
                label: Text('Date', style: TextStyle(color: Colors.white))),
            DataColumn(
                label: Text('Patient Name',
                    style: TextStyle(color: Colors.white))),
            DataColumn(
                label: Text('Results', style: TextStyle(color: Colors.white))),
            DataColumn(
                label: Text('Payment', style: TextStyle(color: Colors.white))),
            DataColumn(
                label: Text('Action', style: TextStyle(color: Colors.white))),
          ],
          rows: widget.contacts.map((contact) {
            return DataRow(
              cells: [
                DataCell(Text(contact.sampleNo.toString())),
                DataCell(Text(contact.date.toString())),
                DataCell(Text(contact.patientName.toString())),
                DataCell(
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SamplesScreen(
                                username: widget.username,
                              ),
                            ),
                          );
                          globals.sample = contact.sampleNo.toString();
                          globals.patientName = contact.patientName.toString();
                        },
                        // style: ElevatedButton.styleFrom(
                        //   primary:
                        //       buttonBackgroundColor, // Set the background color for the button
                        // ),
                        child: Text(
                          "Result",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            FetchTDAdata(contact.sampleNo!).then((value) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final Orientation orientation =
                                      MediaQuery.of(context).orientation;
                                  final bool isPortrait =
                                      orientation == Orientation.portrait;
                                  return AlertDialog(
                                    content: Container(
                                      height: isPortrait
                                          ? MediaQuery.of(context).size.height /
                                              2.0
                                          : MediaQuery.of(context).size.height /
                                              1.0,
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.7
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.7,
                                            ),
                                            child: Text(
                                              "Payment",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      30.0
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      15.0,
                                            ),
                                            child: Divider(
                                              thickness: 1.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              right: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.7
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      10.0,
                                              top: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      20.0
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      10.0,
                                            ),
                                            child: Text(
                                              "Sample No:${contact.sampleNo}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: isPortrait
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        7.7
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        10.0,
                                                top: isPortrait
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        10.0
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        5.7),
                                            child: Text(
                                              "Sample Date: ${contact.date}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              right: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      7.7
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      10.0,
                                              top: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      6.7
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4.0,
                                            ),
                                            child: Text(
                                              "Patient Name: ${contact.patientName}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4.0
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3.0,
                                            ),
                                            child: Divider(
                                              thickness: 1.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3.5
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.7,
                                              right: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      7.7
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      10.0,
                                            ),
                                            child: Text(
                                                "Total: ${tableData[0][1]}",
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.97
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.25,
                                              right: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      7.7
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      10.0,
                                            ),
                                            child: Text("Discount",
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.5
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      1.9,
                                              right: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      7.7
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      10.0,
                                            ),
                                            child: Text(
                                                "Amount to Pay: ${tableData[0][3]}",
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),

                                          /////////////////////////// Save Discount ////////////////////////////////////
                                          Container(
                                            height: isPortrait
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    20.0
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    10.0,
                                            width: isPortrait
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                            margin: EdgeInsets.only(
                                              top: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.2
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      1.63,
                                            ),
                                            // color: Color.fromARGB(255, 182, 34, 55),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  await APIUpdate
                                                      .updateResultEntry(
                                                    endpoint:
                                                        "/api/updatediscount",
                                                    data: {
                                                      "disc": [
                                                        {
                                                          "discount":
                                                              "$discount",
                                                          "VisM_Seq":
                                                              "${contact.sampleNo}"
                                                        }
                                                      ]
                                                    },
                                                  );

                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                            "Data Saved Successfully",
                                                            style: TextStyle(
                                                                fontSize: 18.0),
                                                          ),
                                                        );
                                                      });
                                                } catch (e) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                            "Saving Data Failed",
                                                            style: TextStyle(
                                                                fontSize: 18.0),
                                                          ),
                                                        );
                                                      });
                                                }
                                              },
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1.0),
                                              )),
                                            ),
                                          ),
                                          /////////////////////////////////// TextField Discount ///////////////////////////////////////////////////
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.9
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      9.7,
                                              top: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3.1
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.32,
                                            ),
                                            child: SizedBox(
                                              width: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5.5
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      9.0,
                                              height: isPortrait
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      20.0
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      12.0,
                                              child: TextField(
                                                readOnly: globals.finalize=="False"?true:false,
                                                focusNode: _focusNode,
                                                onSubmitted: (value) {
                                                  double x = double.parse(
                                                          tableData[0][1]) *
                                                      (double.parse(globals
                                                              .Samp_Disc) /
                                                          100.0);

                                                  if (double.parse(value) > x) {
                                                    setState(() {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              content: Text(
                                                                "Discount value is not allowed",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0),
                                                              ),
                                                            );
                                                          });
                                                    });
                                                  } else if (double.parse(
                                                          value) <=
                                                      x) {
                                                    setState(() {
                                                      discount = value;
                                                    });
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: Text(
                                                              "Discount successfully",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0),
                                                            ),
                                                          );
                                                        });
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  hintText: hintText,
                                                  border: OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: isPortrait
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  50.0
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  50.0),
                                                  alignLabelWithHint: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  );
                                },
                              );
                            }).then((value) {
                              hintText = "${tableData[0][2]}";
                            });
                          });
                        },
                        child: Text(
                          "Payment",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                ///////////////////////////// Finalize Button//////////////////////////////////////////////////////////////
                DataCell(
                  SingleChildScrollView(
                    child: Column(children: [
                      Row(
                        children: [
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (widget.finalize == 'False') {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(
                                              "Finalize not allowed",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0),
                                            ),
                                          );
                                        });
                                    //  Future.delayed(Duration(seconds: 2),(){
                                    //   Navigator.of(context).pop();
                                    //  });
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
                                                  "Do you want finalize this sample (${contact.sampleNo})?",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.0),
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      // Execute No Button
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        //
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              7.0,
                                                          margin:
                                                              EdgeInsets.only(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                15.0,
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.7,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color: const Color
                                                                .fromARGB(255,
                                                                119, 115, 115),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18.0,
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
                                                          _finalizeButton(
                                                                  "${contact.sampleNo}")
                                                              .then((value) {
                                                            setState(() {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      content:
                                                                          Text(
                                                                        "Sample Finalized",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18.0),
                                                                      ),
                                                                    );
                                                                  }).then((value) {
                                                                setState(() {
                                                                  contact.finalize =
                                                                      "True";
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
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              7.0,
                                                          margin:
                                                              EdgeInsets.only(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                15.0,
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                30.0,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color: const Color(
                                                                0xff1f63b6),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                              child: Text('Finalize'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 20.0),
                            child: Checkbox(
                              value: contact.finalize == 'True' ? true : false,
                              onChanged: (value) {
                                log("${contact.finalize}");
                                setState(() {
                                  isCheckedList = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      //////////////////////////////  UnFinalize Button ////////////////////////////////////////////////
                      Container(
                        margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 12.0,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (widget.finalize == 'False') {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                          "UnFinalize not allowed",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0),
                                        ),
                                      );
                                    });
                                //  Future.delayed(Duration(seconds: 2),(){
                                //   Navigator.of(context).pop();
                                //  });
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
                                              "Do you want Unfinalize this sample (${contact.sampleNo})?",
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    //
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              7.0,
                                                      margin: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            15.0,
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.7,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 119, 115, 115),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "No",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                      _UnfinalizeButton(
                                                              "${contact.sampleNo}")
                                                          .then((value) {
                                                        setState(() {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  content: Text(
                                                                    "Sample UnFinalized",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18.0),
                                                                  ),
                                                                );
                                                              }).then((value) {
                                                            setState(() {
                                                              contact.finalize =
                                                                  "False";
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
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            15.0,
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            30.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
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
                          child: Text('UnFinalize'),
                        ),
                      ),
                    ]),
                  ),
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
