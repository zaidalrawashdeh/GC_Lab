import 'dart:developer';

import 'package:flutter/material.dart';

class CashTable extends StatefulWidget {
  final List<List<String>> data;
  final double t1;
  const CashTable({super.key, required this.data, required this.t1});

  @override
  State<CashTable> createState() => _CashTableState();
}

class _CashTableState extends State<CashTable> {
    ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    log(screenSize.toString());
   

    return Column(
      children: [
        _buildTableHeader(),
        Container(
          height: screenSize.height*0.70,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Table(
              border: TableBorder.all(
                style: BorderStyle.solid,
                color: Color.fromARGB(255, 228, 224, 224),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FixedColumnWidth(screenSize.width * 0.41), // Sample No
                1: FixedColumnWidth(screenSize.width * 0.41), // Branch
                2: FixedColumnWidth(screenSize.width * 0.41), // Date
                3: FixedColumnWidth(screenSize.width * 0.41), // Patient Name
                4: FixedColumnWidth(screenSize.width * 0.41), // User
                5: FixedColumnWidth(screenSize.width * 0.41), // Amount
              },
              children: [
               
                for (List<String> rowData in widget.data) _buildTableRow(rowData),
                _buildEmptyTableRow()
              ],
            ),
          ),
        ),
      ],
    );
  }

   Widget _buildTableHeader() {
    return Container(
      color: Color(0xff1f63b6),
      child: Row(
        children: [
          _buildTableHeaderCell('Sample No', 0),
          _buildTableHeaderCell('Branch', 1),
          _buildTableHeaderCell('Date', 2),
          _buildTableHeaderCell('Patient Name', 3),
          _buildTableHeaderCell('User', 4),
          _buildTableHeaderCell('Amount', 5),
        ],
      ),
    );
  }

    Widget _buildTableHeaderCell(String text, int columnIndex) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      // margin: EdgeInsets.only(right: 30.0),
      width: screenSize.width * 0.413,
      padding: EdgeInsets.all(8.0),
      // alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> rowData, {bool header = false}) {
    return TableRow(
      decoration:
          header ? BoxDecoration(color: Color(0xFF1F63B6)) : BoxDecoration(),
      children: [
        for (int i = 0; i < rowData.length; i++)
          TableCell(
            child: 
            i==0 
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/7.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 5 && !header ? Alignment.centerRight : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 10 : 12,
                ),
              ),
            )
            :
            i==1
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/4.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 5 && !header ? Alignment.centerRight : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 10 : 12,
                ),
              ),
            )
            :
            i==2
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/5.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 5 && !header ? Alignment.centerRight : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 10 : 12,
                ),
              ),
            )
            :
            i==4
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/7.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 5 && !header ? Alignment.centerRight : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 10 : 12,
                ),
              ),
            )
            :
            Container(
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 5 && !header ? Alignment.centerRight : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 10 : 12,
                ),
              ),
            ),
          ),
        // Add empty cells for rows with fewer children
        for (int i = rowData.length; i < 6; i++)
          TableCell(
            child: Container(),
          ),
      ],
    );
  }

   TableRow _buildEmptyTableRow() {
    return TableRow(
      children: [
        for (int i = 0;
            i < 6;
            i++) // Display empty cells under specific columns
          i == 4
              ? TableCell(
                  child: Container(
                    margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/6.0),
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text("Total"),
                  ),
                )
              : i == 5
                  ? TableCell(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width/3.6
                              ),
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${widget.t1}",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ):Container()
                  
      ],
    );
  }
}
