import 'package:flutter/material.dart';
import 'branch_income.dart';
import 'daily_incom.dart';
import 'daily_samples.dart';
import 'monthly_branch.dart';
import 'monthly_net_revenue.dart';
import 'monthly_top.dart';
import 'payment_details.dart';

class DashboardScreen extends StatefulWidget {
  final String user_id;
  DashboardScreen({Key? key, required this.user_id}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            BranchIncome(
             user_id:widget.user_id ,
            ),
           //////
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),

            //////////
          
            PaymentDetails(
              user_id: widget.user_id,
            ),
           
           //////
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),

            /////////

            MonthlyNetRevenue(
              user_id: widget.user_id,
            ),
          //////////
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),

            /////////
            DailyIncome(
              user_id: widget.user_id,
            ),

            /////////
            Divider(
              thickness:1.0,
              color: Colors.black,
            ),

            //////////
            MonthlyTop(
              user_id: widget.user_id,
            ),

            /////////////
             Divider(
              thickness:1.0,
              color: Colors.black,
            ),

            ////////
            DailySamples(
              user_id: widget.user_id,
            ),

            ///////
              Divider(
              thickness:1.0,
              color: Colors.black,
            ),

            /////////
            MonthlyBranch(
              user_id: widget.user_id,
            ),
          ],
        ),
      ),
    );
  }
}
