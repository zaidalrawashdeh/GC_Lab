import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../API_connect/API_connect.dart';

class PaymentDetails extends StatefulWidget {
  final String user_id;
  const PaymentDetails({super.key, required this.user_id});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  List<List<String>> chartData = [];
  List<_SalesData> data = [];

  late String textField1Value = '';
  late String textField2Value = '';
  DateTime? startDate1;
  DateTime? endDate1;
  bool isLoading = false;
  var responseData;
  List<Map<String, dynamic>> listOfMaps = [];

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    textField1Value = formatter.format(now);
    textField2Value = formatter.format(now);
    Future.delayed(Duration(seconds: 1),(){
      _fetchTodaysData();
    });
    
  }

  // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('PaymentDetailsList') &&
        apiResponse['PaymentDetailsList'] is List) {
      List<dynamic> data = apiResponse['PaymentDetailsList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }

  Future<void> _selectEndDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate1 ?? DateTime.now(),
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
      final formatter1 = DateFormat('yyyy-MM-dd');
      setState(() {
        endDate1 = picked;
        textField2Value = formatter1.format(picked);
        filterDoughnutChart();
      });
    }
  }

  Future<void> _selectStartDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate1 ?? DateTime.now(),
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
      final formatter1 = DateFormat('yyyy-MM-dd');
      setState(() {
        startDate1 = picked;
        textField1Value = formatter1.format(picked);
        filterDoughnutChart();
      });
    }
  }



    Future<void> _fetchTodaysData() async {
   
      final formatter = DateFormat('yyyy-MM-dd');
      final now = DateTime.now();
      final todayDate = formatter.format(now);

      responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/Payment_Details",
        data: {"StartDate": "$todayDate", "EndDate": "$todayDate","UserID": "${widget.user_id}"},
      );
      Map<String, dynamic> ApiResponse = responseData;

      listOfMaps = convertApiResponseToList(ApiResponse);

      setState(() {
        chartData.clear();
        listOfMaps.forEach((row) {
          chartData.add(
            [
              row['tot'].toString(),
              row['paym_name'].toString(),
            ],
          );
        });

        log("$chartData");
     

        List<_SalesData> newData1 = [];
        for (var row1 in chartData) {
          newData1.add(_SalesData(row1[1], double.parse(row1[0])));
        }

        // Update the state to trigger a rebuild with the new data
        setState(() {
          data = newData1;
        });
      });
    
    }

  Future<void> filterDoughnutChart() async {
    if (startDate1 != null) {
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
      final formatter1 = DateFormat('yyyy-MM-dd');
      final startDateString1 = formatter1.format(startDate1!);
      final now = DateTime.now();
      final endDateString1 = formatter1.format(now);

      responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/Payment_Details",
        data: {"StartDate": "$startDateString1", "EndDate": "$endDateString1","UserID": "${widget.user_id}"},
      );
      Map<String, dynamic> ApiResponse = responseData;

      listOfMaps = convertApiResponseToList(ApiResponse);

      setState(() {
        chartData.clear();
        listOfMaps.forEach((row) {
          chartData.add(
            [
              row['tot'].toString(),
              row['paym_name'].toString(),
            ],
          );
        });

        log("$chartData");
        isLoading = false;
        Navigator.of(context).pop();

        List<_SalesData> newData1 = [];
        for (var row1 in chartData) {
          newData1.add(_SalesData(row1[1], double.parse(row1[0])));
        }

        // Update the state to trigger a rebuild with the new data
        setState(() {
          data = newData1;
        });
      });
    }

    if (endDate1 != null) {
      setState(() {
        isLoading = true;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "LOADING....",
              style: TextStyle(color: Colors.white),
            ),
            content: GestureDetector(
                onTap: () {}, child: CircularProgressIndicator()),
            backgroundColor: Color(0xff1f63b6),
          );
        },
      );
      final formatter1 = DateFormat('yyyy-MM-dd');
      final startDateString1 = formatter1.format(startDate1!);
      final formatter2 = DateFormat('yyyy-MM-dd');
      final endDateString1 = formatter2.format(endDate1!);

      responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/Payment_Details",
        data: {"StartDate": "$startDateString1", "EndDate": "$endDateString1","UserID": "${widget.user_id}"},
      );
      Map<String, dynamic> ApiResponse = responseData;

      listOfMaps = convertApiResponseToList(ApiResponse);

      setState(() {
        chartData.clear();
        listOfMaps.forEach((row) {
          chartData.add(
            [
              row['tot'].toString(),
              row['paym_name'].toString(),
            ],
          );
        });

        log("$chartData");
        isLoading = false;
        Navigator.of(context).pop();

        List<_SalesData> newData1 = [];
        for (var row1 in chartData) {
          newData1.add(_SalesData(row1[1], double.parse(row1[0])));
        }

        // Update the state to trigger a rebuild with the new data
        setState(() {
          data = newData1;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 85.0,
                      left: isPortrait
                          ? MediaQuery.of(context).size.width / 40.0
                          : MediaQuery.of(context).size.width / 100.0),
                  child: const Text(
                    "Payment Details",
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  )),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 3.0, right: 5.0, top: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: TextEditingController(text: textField1Value),
                    readOnly: true,
                    onTap: () => _selectStartDate1(context),
                    decoration: const InputDecoration(
                      hintText: 'Start Date',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 85.0,
                      left: MediaQuery.of(context).size.height / 500.0),
                  child: const Text("-")),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 3.0, right: 5.0, top: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: TextEditingController(text: textField2Value),
                    readOnly: true,
                    onTap: () => _selectEndDate1(context),
                    decoration: const InputDecoration(
                      hintText: 'End Date',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height / 50.0,
          ),
          Container(
              margin: EdgeInsets.only(
                right: isPortrait
                    ? MediaQuery.of(context).size.width / 1.47
                    : MediaQuery.of(context).size.width / 1.17,
              ),
              child: const Text(
                "( All Branches )",
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              )),

          // Container Doughnut Chart
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 20.0),
              child: SfCircularChart(
                series: <CircularSeries>[
                  DoughnutSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    dataLabelMapper: (_SalesData data, _) => '${data.sales}',
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.inside,
                      labelIntersectAction: LabelIntersectAction.none,
                    ),
                  ),
                ],
                legend: const Legend(
                  isVisible: true,
                  title: LegendTitle(
                      text:
                          'Payment Methods'), // Customize legend title if needed
                  // overflowMode: LegendItemOverflowMode.wrap,
                ),
              ),
            ),
          ),
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
