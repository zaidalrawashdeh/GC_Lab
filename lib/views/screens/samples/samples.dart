import 'dart:developer';
import 'package:diagnostic/global_variable/globals.dart' as globals;
import 'package:flutter/material.dart';
import '../../../API_connect/API_connect.dart';
import '../Result_entry/Result_entry.dart';

class SamplesScreen extends StatefulWidget {
  final String username;
  const SamplesScreen({super.key, required this.username});

  @override
  State<SamplesScreen> createState() => _SamplesScreenState();
}

class _SamplesScreenState extends State<SamplesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 1),(){
      fetchSamples();
    });
    super.initState();
  }

  final List<List<String>> data = [];
  bool isLoading = false;
  var responseData;
  List<Map<String, dynamic>> listOfMaps=[];
  


   // Convert API Data Form Map<String,dynamic> to List<Map<String,dynamic>>
  List<Map<String, dynamic>> convertApiResponseToList(
      Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> resultList = [];

    // Assuming your API response contains a list under the key 'AllTestsList'
    if (apiResponse.containsKey('PatientSampleList') && apiResponse['PatientSampleList'] is List) {
      List<dynamic> data = apiResponse['PatientSampleList'];

      for (var item in data) {
        if (item is Map<String, dynamic>) {
          resultList.add(item);
        }
      }
    }

    return resultList;
  }

  Future<void> fetchSamples() async {
    responseData = await APIHelper.connect(
        context: context,
        endpoint: "/api/SampleParts",
        data: {
       "VisM_Seq":"${globals.sample}"
        },
      );
      Map<String, dynamic> ApiResponse = responseData;
      listOfMaps = convertApiResponseToList(ApiResponse);

    setState(() {
      data.clear();
      listOfMaps.forEach((row) {
        data.add([
          row['Father_Sec'].toString(),
          row['Sec_Name'].toString(),
        ]);
      });
      log("$data");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Patient Samples",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 10.0),
            Expanded(
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ResultEntry(
                                  username: widget.username,
                                  patientName: globals.patientName,
                                  sampleNo: globals.sample,
                                  buttonID: "${data[index][0]}",
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF173D7C),
                                  Color(0xFF0096DA),
                                ],
                              ),
                            ),
                            height: MediaQuery.of(context).size.height / 10.0,
                            child: Center(
                                child: Text(
                              "${data[index][1]}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0),
                            )),
                          ),
                        ),


                        //////////
                      ),
                    );
                  })),
            ),
          ],
        ));
  }
}
