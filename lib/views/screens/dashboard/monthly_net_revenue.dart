import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../API_connect/API_connect.dart';

class MonthlyNetRevenue extends StatefulWidget {
  final String user_id;
  const MonthlyNetRevenue({super.key, required this.user_id});

  @override
  State<MonthlyNetRevenue> createState() => _MonthlyNetRevenueState();
}

class _MonthlyNetRevenueState extends State<MonthlyNetRevenue> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 1),(){
      _fetchTodaysData();
    });
    super.initState();
  }
  TextEditingController controllerYear = TextEditingController();
  List<List<String>> chartData = [];
  List<BarCahrtData> data = [];
  bool isLoading = false;
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];
  @override
  void dispose() {
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
    if (apiResponse.containsKey('MonthlyNetRevenueList') &&
        apiResponse['MonthlyNetRevenueList'] is List) {
      List<dynamic> data = apiResponse['MonthlyNetRevenueList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }




  Future<void> _fetchTodaysData() async {
    final formatterYear=DateFormat('yyy');
    final nowYear=formatterYear.format(DateTime.now());
    
    responseData = await APIHelper.connect(
      context: context,
      endpoint: "/api/Monthly_Net_Revenue",
      data: {"Year": "$nowYear","UserID": "${widget.user_id}"},
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);

    setState(() {
      chartData.clear();
      listOfMaps.forEach(
        (row) {
          chartData.add(
            [
              row['dt1'].toString(),
              row['netIncome'].toString(),
            ],
          );
        },
      );
      log("$chartData");
    
      List<BarCahrtData> newData = [];
      for (var row in chartData) {
        newData.add(BarCahrtData(row[0], double.parse(row[1])));
      }

      // Update the state to trigger a rebuild with the new data
      data = newData;
    });
  }


  Future<void> fetchMonthlyNet() async {
    String year = controllerYear.text;
    if (year.isNotEmpty) {
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
      endpoint: "/api/Monthly_Net_Revenue",
      data: {"Year": "$year","UserID": "${widget.user_id}"},
    );
    Map<String, dynamic> ApiResponse = responseData;

    listOfMaps = convertApiResponseToList(ApiResponse);

    setState(() {
      chartData.clear();
      listOfMaps.forEach(
        (row) {
          chartData.add(
            [
              row['dt1'].toString(),
              row['netIncome'].toString(),
            ],
          );
        },
      );
      log("$chartData");
      isLoading = false;
      Navigator.of(context).pop();
      List<BarCahrtData> newData = [];
      for (var row in chartData) {
        newData.add(BarCahrtData(row[0], double.parse(row[1])));
      }

      // Update the state to trigger a rebuild with the new data
      data = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy');
    final now = DateTime.now();
    String year = formatter.format(now);

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
                      ? MediaQuery.of(context).size.width / 3.0
                      : MediaQuery.of(context).size.width / 1.47,
                ),
                child: Text(
                  "Monthly Net Revenue for The Year:",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ),

              //////////
              Container(
                margin: EdgeInsets.only(
                  left: isPortrait
                      ? MediaQuery.of(context).size.width / 1.6
                      : MediaQuery.of(context).size.width / 3.2,
                  top: MediaQuery.of(context).size.height / 77.0,
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
                      fetchMonthlyNet();
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

              ////////////////
              Container(
                margin: EdgeInsets.only(
                    top: isPortrait
                        ? MediaQuery.of(context).size.height / 15.0
                        : MediaQuery.of(context).size.height / 9.0),
                child: Text(
                  "( All Branches )",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),

              ////////////
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 20.0,
          ),

          ////////
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: MediaQuery.of(context).size.width * 2.3,
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
                  SplineAreaSeries<BarCahrtData, String>(
                    color: Color(0xff1f63b6),
                    dataSource: data,
                    xValueMapper: (BarCahrtData sales, _) => sales.code,
                    yValueMapper: (BarCahrtData sales, _) => sales.value,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.inside,
                    ),

                    legendItemText:
                        'NetIncome', // Set your desired legend name here
                  ),
                ],
              ),
            ),
          ),

          ///////////
        ],
      ),
    );
  }
}

class BarCahrtData {
  final String code;
  final double value;
  BarCahrtData(this.code, this.value);
}
