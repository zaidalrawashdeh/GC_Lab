import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';

class APIHelper {

   static Future<dynamic> connect({
    required BuildContext context,
    required String endpoint,
    
    required dynamic data,
  }) async {
    
    log("Connecting...");
    try {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: GestureDetector(
              // Ignore clicking on the inner content of the dialog
              onTap: () {},
              child: const Column(
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
            backgroundColor: const Color(0xff1f63b6),
          );
        },
      );
      
      
     var url =
      Uri.http('62.171.174.119:35', '$endpoint');

  // Await the http get response, then decode the json-formatted response.
  var response = await http.post(url,body:data);
  var responseData=jsonDecode(response.body);
   

   
      return responseData;
    } catch (e) {
      log(e.toString());
    } 
    finally {
      Navigator.pop(context);
    }
  }
}
