import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../API_connect/API_connect.dart';

class DailyIncome extends StatefulWidget {
  final String user_id;
  const DailyIncome({super.key, required this.user_id});

  @override
  State<DailyIncome> createState() => _DailyIncomeState();
}

class _DailyIncomeState extends State<DailyIncome> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 1), () {
      _fetchTodaysData();
    });
    super.initState();
  }

  TextEditingController controllerMonth = TextEditingController();
  TextEditingController controllerYear = TextEditingController();
  final List<List<String>> chartData = [];
  List<_SalesData> data = [];
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];
  bool isLoading = false;

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('DailyIncomeList') &&
        apiResponse['DailyIncomeList'] is List) {
      List<dynamic> data = apiResponse['DailyIncomeList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }

  Future<void> _fetchTodaysData() async {
    final formatterYear = DateFormat('yyyy');
    final formatterMonth = DateFormat('MM');
    final nowYear = formatterYear.format(DateTime.now());
    final nowMonth = formatterMonth.format(DateTime.now());

    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Daily_Income",
      data: {"Month": "$nowMonth", "Year": "$nowYear","UserID": "${widget.user_id}"},
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);
    setState(() {
      chartData.clear();
      listOfMaps.forEach(
        (row) {
          chartData.add(
            [
              row['dt'].toString(),
              row['netIncome'].toString(),
              row['CompanyClaim'].toString(),
              row['CashIncome'].toString(),
            ],
          );
        },
      );
      log("$chartData");

      List<_SalesData> newData = [];
      for (var row in chartData) {
        newData.add(_SalesData(
          row[0],
          double.parse(row[1]), // Net Income
          double.parse(row[2]), // CompanyClaim
          double.parse(row[3]), // CashIncome
        ));
      }

      // Update the state to trigger a rebuild with the new data
      setState(() {
        data = newData;
      });
    });
  }

  Future<void> fetchDailyIncomeData() async {
    String month = controllerMonth.text;
    String year = controllerYear.text;
    if (month.isNotEmpty && year.isNotEmpty) {
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
    }

    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Daily_Income",
      data: {"Month": "$month", "Year": "$year","UserID": "${widget.user_id}"},
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);
    setState(() {
      chartData.clear();
      listOfMaps.forEach(
        (row) {
          chartData.add(
            [
              row['dt'].toString(),
              row['netIncome'].toString(),
              row['CompanyClaim'].toString(),
              row['CashIncome'].toString(),
            ],
          );
        },
      );
      log("$chartData");
      isLoading = false;
      Navigator.of(context).pop();
      List<_SalesData> newData = [];
      for (var row in chartData) {
        newData.add(_SalesData(
          row[0],
          double.parse(row[1]), // Net Income
          double.parse(row[2]), // CompanyClaim
          double.parse(row[3]), // CashIncome
        ));
      }

      // Update the state to trigger a rebuild with the new data
      setState(() {
        data = newData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy');
    final formatter1 = DateFormat('MM');
    final now = DateTime.now();
    String year = formatter.format(now);
    String month = formatter1.format(now);

    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 50.0
                        : MediaQuery.of(context).size.height / 30.0,
                    right: isPortrait
                        ? MediaQuery.of(context).size.width / 1.9
                        : MediaQuery.of(context).size.width / 1.30,
                  ),
                  child: Text("Daily Income for Month:",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold))),

              ///////
              Container(
                margin: EdgeInsets.only(
                  left: isPortrait
                      ? MediaQuery.of(context).size.width / 2.3
                      : MediaQuery.of(context).size.width / 4.5,
                  top: MediaQuery.of(context).size.height / 70.0,
                ),
                child: SizedBox(
                  width: isPortrait
                      ? MediaQuery.of(context).size.width / 5.5
                      : MediaQuery.of(context).size.width / 9.0,
                  height: isPortrait
                      ? MediaQuery.of(context).size.height / 20.0
                      : MediaQuery.of(context).size.height / 10.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: controllerMonth,
                    onSubmitted: (value) {
                      fetchDailyIncomeData();
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

              ////////////
              Container(
                margin: EdgeInsets.only(
                  left: isPortrait
                      ? MediaQuery.of(context).size.width / 1.57
                      : MediaQuery.of(context).size.width / 2.9,
                  top: MediaQuery.of(context).size.height / 70.0,
                ),
                child: SizedBox(
                  width: isPortrait
                      ? MediaQuery.of(context).size.width / 5.5
                      : MediaQuery.of(context).size.width / 9.0,
                  height: isPortrait
                      ? MediaQuery.of(context).size.height / 20.0
                      : MediaQuery.of(context).size.height / 10.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: controllerYear,
                    onSubmitted: (value) {
                      fetchDailyIncomeData();
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

              //////////////
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 20.0,
          ),

          ///////
          // Container Column Chart
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
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.netIncome,
                    name: 'Net Income',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      // Set the label position to top
                    ),
                  ),
                  ColumnSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.companyClaim,
                    name: 'Company Claim',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      // Set the label position to top
                    ),
                  ),
                  ColumnSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.cashIncome,
                    name: 'Cash Income',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      // Set the label position to top
                    ),
                  ),
                ],
              ),
            ),
          ),

          /////////////////
        ],
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.netIncome, this.companyClaim, this.cashIncome);

  final String year;
  final double netIncome;
  final double companyClaim;
  final double cashIncome;
}
