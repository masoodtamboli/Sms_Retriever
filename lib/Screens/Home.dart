import "package:sms_retriever/Widgets/CustomIcons.dart";
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sms_retriever/Constants/Values.dart';
import 'package:sms_retriever/Controllers/MessageController.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MessageController _msgController = Get.put(MessageController());
  TextEditingController _textEditingController = TextEditingController();
  bool isDateSelected = false;
  bool isBodySelected = false;
  bool isSenderIdSelected = false;

  void showToast(String text) {
    Fluttertoast.showToast(msg: text);
  }

  @override
  void initState() {
    super.initState();
    _msgController.fetchAllSms();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(30, 35, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: size.width * 0.6,
                      child: TextFormField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _msgController.isDateRangeSelected
                                ? Icon(
                                    CustomIcons.calendar_check_o,
                                    size: 20,
                                    color: primaryColor,
                                  )
                                : Icon(
                                    CustomIcons.calendar,
                                    size: 20,
                                    color: primaryColor,
                                  ),
                            onPressed: () {
                              Get.defaultDialog(
                                content: SfDateRangePicker(
                                  initialSelectedRange: PickerDateRange(
                                      _msgController.startDate,
                                      _msgController.endDate),
                                  cancelText: "Reset",
                                  onSubmit: (Object args) {
                                    if (args is PickerDateRange) {
                                      _msgController.isDateRangeSelected = true;
                                      _msgController.startDate =
                                          args.startDate!;
                                      _msgController.endDate = args.endDate!;
                                    }
                                    setState(() {});
                                    Get.back();
                                  },
                                  onCancel: () {
                                    _msgController.isDateRangeSelected = false;
                                    _msgController.startDate = null;
                                    _msgController.endDate = null;
                                    setState(() {});
                                    Get.back();
                                  },
                                  selectionMode:
                                      DateRangePickerSelectionMode.range,
                                  showActionButtons: true,
                                ),
                              );
                            },
                          ),
                          contentPadding: EdgeInsets.only(left: 20),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          filled: true,
                          hintText: "Search",
                          fillColor: Colors.white70,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        setState(() {
                          _msgController.findSms(
                              address: _textEditingController.text);
                        });
                      },
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        "Sort by:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!isDateSelected) {
                              sortByDateColor = secondaryColor;
                              isDateSelected = true;
                              if (isBodySelected || isSenderIdSelected) {
                                sortByBodyColor = Colors.grey[200];
                                sortBySenderIdColor = Colors.grey[200];
                                isSenderIdSelected = false;
                                isBodySelected = false;
                              }

                              _msgController.findSms(
                                  address: _textEditingController.text,
                                  isDateSelected: isDateSelected);
                            } else {
                              sortByDateColor = Colors.grey[200];
                              isDateSelected = false;
                              _msgController.findSms(
                                  address: _textEditingController.text);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: sortByDateColor,
                          ),
                          width: 50,
                          height: 30,
                          child: Center(
                            child: Text(
                              "Date",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!isBodySelected) {
                              sortByBodyColor = secondaryColor;
                              isBodySelected = true;
                              if (isDateSelected || isSenderIdSelected) {
                                sortByDateColor = Colors.grey[200];
                                sortBySenderIdColor = Colors.grey[200];
                                isSenderIdSelected = false;
                                isDateSelected = false;
                              }
                              _msgController.findSms(
                                  address: _textEditingController.text,
                                  isBodySelected: isBodySelected);
                            } else {
                              sortByBodyColor = Colors.grey[200];
                              isBodySelected = false;
                              _msgController.findSms(
                                  address: _textEditingController.text);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: sortByBodyColor,
                          ),
                          width: 80,
                          height: 30,
                          child: Center(
                            child: Text(
                              "Content",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!isSenderIdSelected) {
                              sortBySenderIdColor = secondaryColor;
                              isSenderIdSelected = true;
                              if (isDateSelected || isBodySelected) {
                                sortByDateColor = Colors.grey[200];
                                sortByBodyColor = Colors.grey[200];
                                isBodySelected = false;
                                isDateSelected = false;
                              }
                              _msgController.findSms(
                                  address: _textEditingController.text,
                                  isSenderIdSelected: isSenderIdSelected);
                            } else {
                              sortBySenderIdColor = Colors.grey[200];
                              isSenderIdSelected = false;
                              _msgController.findSms(
                                  address: _textEditingController.text);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: sortBySenderIdColor,
                          ),
                          width: 80,
                          height: 30,
                          child: Center(
                            child: Text(
                              "Sender Id",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[200],
              ),
              child: GetBuilder<MessageController>(
                builder: (snapshot) => ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20);
                  },
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  shrinkWrap: true,
                  itemCount: snapshot.messages.length,
                  itemBuilder: (context, index) {
                    return FittedBox(
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: GestureDetector(
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            snapshot.messages[index].address));
                                    showToast("Sender ID copied to clipboard");
                                  },
                                  child: Text(
                                    "Sender: ${snapshot.messages[index].address}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: size.width * 0.8,
                                child: GestureDetector(
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(
                                        text: snapshot.messages[index].body));
                                    showToast(
                                        "Message Content copied to clipboard");
                                  },
                                  child: Text(
                                    "${snapshot.messages[index].body}",
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: size.width * 0.8,
                                child: GestureDetector(
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(
                                        text: DateFormat('dd-MMM-yyyy  kk:mm a')
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    snapshot.messages[index]
                                                        .date!))));
                                    showToast(
                                        "Date & Time copied to clipboard");
                                  },
                                  child: Text(
                                    "Timespan: " +
                                        DateFormat('dd-MMM-yyyy  kk:mm a')
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    snapshot.messages[index]
                                                        .date!)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
