import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sms_retriever/Constants/Values.dart';
import 'package:sms_retriever/Controllers/MessageController.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  MessageController _msgController = Get.put(MessageController());
  bool msgSize = false;

  @override
  void initState() {
    super.initState();
    if (_msgController.messages.length > 250) {
      setState(() {
        msgSize = true;
      });
    }
  }

  // _handleDateSelection(DateRangePickerSelectionChangedArgs args) {
  //
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _msgController.messages.isEmpty
          ? Column(
              children: [
                Center(
                  child: Container(
                    width: size.width * 0.8,
                    height: size.height / 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/illustrations/empty.png"),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Nothing to show!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            )
          : msgSize
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: size.width * 0.8,
                          height: size.height / 2,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/illustrations/tooHuge.png"),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Data too Huge to show",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                msgSize = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Proceed"),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward_outlined, size: 18),
                              ],
                            )),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      DataTable2(
                        dataRowHeight: 150,
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => secondaryColor),
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 600,
                        columns: [
                          DataColumn2(
                            label: Text("Sender Id"),
                            size: ColumnSize.M,
                          ),
                          DataColumn2(
                            label: Text('Receiver Id'),
                            size: ColumnSize.M,
                          ),
                          DataColumn2(
                            label: Text('Content'),
                            size: ColumnSize.L,
                          ),
                          DataColumn2(
                            label: Text('Date & Time'),
                            size: ColumnSize.S,
                          ),
                        ],
                        rows: <DataRow>[
                          for (int j = 0;
                              j < _msgController.messages.length;
                              j++)
                            DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text(_msgController.messages[j].address
                                      .toString()),
                                ),
                                DataCell(
                                  Text(_msgController.receiverMobNum.substring(
                                      2,
                                      (_msgController.receiverMobNum.length))),
                                ),
                                DataCell(
                                  Text(_msgController.messages[j].body
                                      .toString()),
                                ),
                                DataCell(Text(DateFormat('dd-MMM-yyyy  kk:mm a')
                                    .format(DateTime.fromMillisecondsSinceEpoch(
                                        _msgController.messages[j].date!)))),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}
