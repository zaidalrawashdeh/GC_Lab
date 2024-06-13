// import 'dart:convert';
// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;

// import 'package:flutter/material.dart';

// class SendNotification extends StatefulWidget {
//   const SendNotification({super.key});

//   @override
//   State<SendNotification> createState() => _SendNotificationState();
// }

// class _SendNotificationState extends State<SendNotification> {
//   TextEditingController titleMessage=TextEditingController();
//   TextEditingController bodyMessage=TextEditingController();

// @override
//   void dispose() {
//     titleMessage.dispose();
//     bodyMessage.dispose();
//     super.dispose();
//   }

//   Future<void> sendNotificationToTokens(List<String> tokens, String title, String body) async {
//   final String serverKey = 'AAAAXXG8fWc:APA91bGqEMCc4ULOnBIZc-978b28Psx8x-8_33Hy_Fgb_oipW1EYcIDZKUaJMBt50iTkinsW7jYgUP47gJlCGD47jUx4nz7MMw6wgEVckQL7ov06zr44msGqd53r7q1rRvNK2h18uHIO';
//   final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

//   final Map<String, dynamic> notification = {
//     'title': title,
//     'body': body,
//   };

//   final Map<String, dynamic> message = {
//     'notification': notification,
//     'registration_ids': tokens,
//   };

//   final http.Response response = await http.post(
//     url,
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$serverKey',
//     },
//     body: jsonEncode(message),
//   );

//   if (response.statusCode == 200) {
//     log('Notification sent successfully');
//   } else {
//     log('Error sending notification: ${response.reasonPhrase}');
//   }
// }



// Future<void> sendNotificationsToAllTokens(String title, String body) async {
//   try {
//     // Retrieve tokens from the database
//     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users_token').doc('X5AQyP53BwKVQY1YTPh6').get();
    
//     if (userSnapshot.exists && userSnapshot.data() != null) {
//       List<String> tokens = List<String>.from((userSnapshot.data() as Map<String, dynamic>)['token'] ?? []);
      
//       // Send notifications to tokens
//       await sendNotificationToTokens(tokens, title, body);
//     } else {
//       log('User document not found or does not have tokens.');
//     }
//   } catch (e) {
//     log('Error sending notifications: $e');
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     final Orientation orientation=MediaQuery.of(context).orientation;
//     final bool isPortrait=orientation==Orientation.portrait;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Send Notification"),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             margin: EdgeInsets.only(
//               top:isPortrait?MediaQuery.of(context).size.height/20.0: 
//               MediaQuery.of(context).size.height/10.0,
//               left: isPortrait?MediaQuery.of(context).size.width/20.0:
//               MediaQuery.of(context).size.width/10.0,
//             ),
//             child: Text("Title:",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold) 
//             ),
//             ),


//             ////////////
//             Container(
//               height: isPortrait?MediaQuery.of(context).size.height/20.0:
//               MediaQuery.of(context).size.height/10.0,
//               margin: EdgeInsets.only(
//                 top: isPortrait?MediaQuery.of(context).size.height/25.0:
//                 MediaQuery.of(context).size.height/12.0,
//                 left: isPortrait?MediaQuery.of(context).size.width/6.0:
//                 MediaQuery.of(context).size.width/6.0,
//               ),
//               width: MediaQuery.of(context).size.width/3.0,
//               child: TextField(
//                 controller: titleMessage,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.only(
//                     bottom: isPortrait?MediaQuery.of(context).size.height/50.0:
//                     MediaQuery.of(context).size.height/30.0,
//                     left: isPortrait?MediaQuery.of(context).size.width/50.0:
//                     MediaQuery.of(context).size.width/20.0,
//                   )
//                 ),
//               ),
//             ),



//             //////////////
//                Container(
//             margin: EdgeInsets.only(
//               top:isPortrait?MediaQuery.of(context).size.height/7.0: 
//               MediaQuery.of(context).size.height/3.5,
//               left: isPortrait?MediaQuery.of(context).size.width/20.0:
//               MediaQuery.of(context).size.width/10.0,
//             ),
//             child: Text("Message:",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold) 
//             ),
//             ),


//             /////////////////
//             Container(
//               height: MediaQuery.of(context).size.height/4.0,
//               margin: EdgeInsets.only(
//                 top: isPortrait?MediaQuery.of(context).size.height/7.4:
//                 MediaQuery.of(context).size.height/4.0,
//                 left: isPortrait?MediaQuery.of(context).size.width/3.7:
//                 MediaQuery.of(context).size.width/4.7,
//               ),
//               width: MediaQuery.of(context).size.width/1.7,
//               child: TextField(
//                 controller: bodyMessage,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),


//             //////////
            

//             Container(
//               width: MediaQuery.of(context).size.width/1.3,
//               margin: EdgeInsets.only(
//                 top: isPortrait?MediaQuery.of(context).size.height/3.0:
//                 MediaQuery.of(context).size.height/1.7,
//                 left: isPortrait?MediaQuery.of(context).size.width/9.0:
//                 MediaQuery.of(context).size.width/7.0
//               ),
//               child: ElevatedButton(onPressed: (){
//                 setState(() {
//                   sendNotificationsToAllTokens("${titleMessage.text}","${bodyMessage.text}");
//                 });
//               }, child: Text("Send"),
//               style: ButtonStyle(
//                 shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)))
//               ),
//               ),
//               ),
//         ],
//       ),
//     );
//   }
// }