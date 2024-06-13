import 'dart:developer';
import 'package:flutter/material.dart';

class IncomeTable extends StatefulWidget {
  final List<List<String>> data;
  final double t1;
  final double t2;
  final double t3;
  final double t4;
  final double t5;
  final double t6;
  final double t7;
  final double t8;

  const IncomeTable(
      {Key? key,
      required this.data,
      required this.t1,
      required this.t2,
      required this.t3,
      required this.t4,
      required this.t5,
      required this.t6,
      required this.t7,
      required this.t8})
      : super(key: key);

  @override
  State<IncomeTable> createState() => _IncomeTableState();
}

class _IncomeTableState extends State<IncomeTable> {
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
                0: FixedColumnWidth(screenSize.width * 0.38), // vism_seq
                1: FixedColumnWidth(screenSize.width * 0.38), // Br_Code
                2: FixedColumnWidth(screenSize.width * 0.38), // vism_date
                3: FixedColumnWidth(screenSize.width * 0.40), // Patient Name
                4: FixedColumnWidth(screenSize.width * 0.38), // doc_name
                5: FixedColumnWidth(screenSize.width * 0.38), // ins_name
                6: FixedColumnWidth(screenSize.width * 0.40), // total
                7: FixedColumnWidth(screenSize.width * 0.40), // CDisc
                8: FixedColumnWidth(screenSize.width * 0.40), // pShare
                9: FixedColumnWidth(screenSize.width * 0.40), // Pdisc
                10: FixedColumnWidth(screenSize.width * 0.40), // income
                11: FixedColumnWidth(screenSize.width * 0.40), // paid
                12: FixedColumnWidth(screenSize.width * 0.40), // cClaim
                13: FixedColumnWidth(screenSize.width * 0.40), // remain
              },
              children: [
             
                for (List<String> rowData in widget.data) _buildTableRow(rowData),
                _buildEmptyTableRow(),
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
          _buildTableHeaderCell('vism_seq', 0),
          _buildTableHeaderCell('Br_Code', 1),
          _buildTableHeaderCell('vism_date', 2),
          _buildTableHeaderCell('Patient Name', 3),
          _buildTableHeaderCell('doc_name', 4),
          _buildTableHeaderCell('ins_name', 5),
          _buildTableHeaderCell('total', 6),
          _buildTableHeaderCell('CDisc', 7),
          _buildTableHeaderCell('pShare', 8),
          _buildTableHeaderCell('Pdisc', 9),
          _buildTableHeaderCell('income', 10),
          _buildTableHeaderCell('paid', 11),
          _buildTableHeaderCell('C-Claim', 12),
          _buildTableHeaderCell('remain', 13),
        ],
      ),
    );
  }

    Widget _buildTableHeaderCell(String text, int columnIndex) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      // margin: EdgeInsets.only(right: 30.0),
      width: screenSize.width * 0.392,
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
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/6.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            )
            :
             i==1
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/6.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            )
            :
             i==2
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/9.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            )
            :
             i==6
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/6.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            )
            :
             i==7
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/6.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            )
            :
             i==8
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/6.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            )
            :
            
             i==9
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/6.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            )
            :
             i==10
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/6.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            )
            :
            
             i==11
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/6.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            )
            :
             i==12
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/6.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            )
            :
             i==13
            ?
            Container(
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/5.0),
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            )
            :
            
            Container(
              padding: EdgeInsets.all(8.0),
              alignment:
                  i == 4 && !header ? Alignment.center : Alignment.center,
              child: Text(
                rowData[i],
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  color: header ? Colors.white : Colors.black,
                  fontSize: header ? 12 : 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  TableRow _buildEmptyTableRow() {
    return TableRow(
      children: [
        for (int i = 0;
            i < 14;
            i++) // Display empty cells under specific columns
          i == 5
              ? TableCell(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text("Total"),
                  ),
                )
              : i == 6
                  ? TableCell(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/20.0),
                              padding: EdgeInsets.all(8.0),
                              
                              child: Text(
                                "${widget.t1}",
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : i == 7
                      ? TableCell(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                               margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/20.0),
                                  padding: EdgeInsets.all(8.0),
                                  
                                  child: Text("${widget.t2}"),
                                ),
                              ],
                            ),
                          ),
                        )
                      : i == 8
                          ? TableCell(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/20.0),
                                      padding: EdgeInsets.all(8.0),
                                     
                                      child: Text("${widget.t3}"),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : i == 9
                              ? TableCell(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Container(
                                       margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/20.0),
                                          padding: EdgeInsets.all(8.0),
                                         
                                          child: Text("${widget.t4}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : i == 10
                                  ? TableCell(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Container(
                                            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/20.0),
                                              padding: EdgeInsets.all(8.0),
                                              
                                              child: Text("${widget.t5}"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : i == 11
                                      ? TableCell(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Container(
                                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/20.0),
                                                  padding: EdgeInsets.all(8.0),
                                                 
                                                  child: Text("${widget.t6}"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : i == 12
                                          ? TableCell(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                     margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/20.0),
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                     
                                                      child: Text("${widget.t7}"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : i == 13
                                              ? TableCell(
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/20.0),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                         
                                                          child: Text("${widget.t8}"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : TableCell(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/7.0),
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    
                                                    child: Text(""),
                                                  ),
                                                ),
      ],
    );
  }
}
