import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:telephony/telephony.dart';

class MessageController extends GetxController {
  Telephony telephony = Telephony.instance;
  List<SmsMessage> messages = [];
  String receiverMobNum = "";
  bool isDateRangeSelected = false;
  var startDate;
  var endDate;

  fetchAllSms() async {
    messages = await telephony.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
    );
    try {
      receiverMobNum = (await MobileNumber.mobileNumber)!;
    } catch (e) {
      debugPrint("$e");
    }
    update();
  }

  findSms(
      {String address = "",
      bool isDateSelected = false,
      bool isBodySelected = false,
      bool isSenderIdSelected = false}) async {
    if (address.isNotEmpty) {
      messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        filter: SmsFilter.where(SmsColumn.ADDRESS).like(address),
        sortOrder: [
          if (isDateSelected)
            OrderBy(SmsColumn.DATE, sort: Sort.ASC)
          else if (isBodySelected)
            OrderBy(SmsColumn.BODY, sort: Sort.ASC)
          else if (isSenderIdSelected)
            OrderBy(SmsColumn.ADDRESS, sort: Sort.ASC)
        ],
      );
      if (isDateRangeSelected) findBetweenDates();
    } else {
      messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        sortOrder: [
          if (isDateSelected)
            OrderBy(SmsColumn.DATE, sort: Sort.ASC)
          else if (isBodySelected)
            OrderBy(SmsColumn.BODY, sort: Sort.ASC)
          else if (isSenderIdSelected)
            OrderBy(SmsColumn.ADDRESS, sort: Sort.ASC)
        ],
      );
      if (isDateRangeSelected) findBetweenDates();
    }
    update();
  }

  findBetweenDates() async {
    List<SmsMessage> newMsgs = messages;
    messages = [];
    newMsgs.forEach((element) {
      if (element.date! > startDate.millisecondsSinceEpoch &&
          element.date! < endDate.millisecondsSinceEpoch) {
        messages.add(element);
      }
    });
    update();
  }
}
