import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../API_connect/API_connect.dart';

class BranchIncome extends StatefulWidget {
  final String user_id;
  const BranchIncome({super.key, required this.user_id});

  @override
  State<BranchIncome> createState() => _BranchIncomeState();
}

class _BranchIncomeState extends State<BranchIncome> {
  final List<List<String>> chartData = [];
  List<_SalesData> data = [];

  late String textField1Value = '';
  late String textField2Value = '';
  DateTime? startDate;
  DateTime? endDate;
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];

  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    textField1Value = formatter.format(now);
    textField2Value = formatter.format(now);
    Future.delayed(Duration(seconds: 1), () {
      _fetchTodaysData();
    });
  }

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('BranchIncomeList') &&
        apiResponse['BranchIncomeList'] is List) {
      List<dynamic> data = apiResponse['BranchIncomeList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
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
        fetchBranchIncomeData();
      });
    }
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
        fetchBranchIncomeData();
      });
    }
  }

  Future<void> _fetchTodaysData() async {
    final formatter = DateFormat('yyyy-MM-dd');

    final now = DateTime.now();

    final todayDate = formatter.format(now);

    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Branch_Income",
      data: {"startDate": "$todayDate", "endDate": "$todayDate","UserID": "${widget.user_id}"},
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);
    setState(() {
      chartData.clear();
      listOfMaps.forEach(
        (row) {
          chartData.add(
            [
              row['br_e_name'].toString(),
              row['netIncome'].toString(),
            ],
          );
        },
      );
      log("$chartData");

      List<_SalesData> newData = [];
      for (var row in chartData) {
        newData.add(_SalesData(row[0], double.parse(row[1])));
      }

      // Update the state to trigger a rebuild with the new data
      setState(() {
        data = newData;
      });
    });
  }

  Future<void> fetchBranchIncomeData() async {
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
        endpoint: "/api/Branch_Income",
        data: {"startDate": "$startDateString", "endDate": "$endDateString","UserID": "${widget.user_id}"},
      );
      Map<String, dynamic> ApiResponse = responseData;

      listOfMaps = convertApiResponseToList(ApiResponse);
      setState(() {
        chartData.clear();
        listOfMaps.forEach(
          (row) {
            chartData.add(
              [
                row['br_e_name'].toString(),
                row['netIncome'].toString(),
              ],
            );
          },
        );
        log("$chartData");
        isLoading = false;
        Navigator.of(context).pop();

        List<_SalesData> newData = [];
        for (var row in chartData) {
          newData.add(_SalesData(row[0], double.parse(row[1])));
        }

        // Update the state to trigger a rebuild with the new data
        setState(() {
          data = newData;
        });
      });
    }

    if (endDate != null) {
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
      final formatter2 = DateFormat('yyyy-MM-dd');

      final endDateString = formatter2.format(endDate!);

      responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/Branch_Income",
        data: {"startDate": "$startDateString", "endDate": "$endDateString","UserID": "${widget.user_id}"},
      );
      Map<String, dynamic> ApiResponse = responseData;

      listOfMaps = convertApiResponseToList(ApiResponse);
      setState(() {
        chartData.clear();
        listOfMaps.forEach(
          (row) {
            chartData.add(
              [
                row['br_e_name'].toString(),
                row['netIncome'].toString(),
              ],
            );
          },
        );
        log("$chartData");
        isLoading = false;
        Navigator.of(context).pop();

        List<_SalesData> newData = [];
        for (var row in chartData) {
          newData.add(_SalesData(row[0], double.parse(row[1])));
        }

        // Update the state to trigger a rebuild with the new data
        setState(() {
          data = newData;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 85.0,
                      left: MediaQuery.of(context).size.width / 85.0),
                  child: Text(
                    "Branch Income for Period",
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  )),

              ///
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 3.0, right: 5.0, top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 9.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: TextEditingController(text: textField1Value),
                    readOnly: true,
                    onTap: () => _selectStartDate(context),
                    decoration: InputDecoration(
                      hintText: 'Start Date',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              ///
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 85.0,
                      left: MediaQuery.of(context).size.height / 500.0),
                  child: Text("-")),

              ////
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 3.0, right: 5.0, top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 9.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: TextEditingController(text: textField2Value),
                    readOnly: true,
                    onTap: () => _selectEndDate(context),
                    decoration: InputDecoration(
                      hintText: 'End Date',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              ///
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 20.0,
          ),

          ////
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: MediaQuery.of(context).size.width * 2.3,
              height: MediaQuery.of(context).size.height / 2.0,
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
                series: <CartesianSeries<_SalesData, String>>[
                  ColumnSeries<_SalesData, String>(
                    color: Color(0xff1f63b6),
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Net Income',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      // Set the label position to top
                    ),
                  )
                ],
              ),
            ),
          ),

          /////
        ],
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
