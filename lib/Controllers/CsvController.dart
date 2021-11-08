import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sms_retriever/Controllers/MessageController.dart';

class CsvController extends GetxController {
  MessageController _msgController = Get.put(MessageController());
  var csvContent = [[]];
  late Directory directory;
  String myfilepath = "";
  var fields;
  generateCsv() async {
    csvContent.clear();
    for (int i = 0; i < _msgController.messages.length; i++) {
      csvContent.add([
        _msgController.messages[i].address,
        _msgController.receiverMobNum
            .substring(2, (_msgController.receiverMobNum.length)),
        _msgController.messages[i].body,
        DateFormat('dd-MMM-yyyy  kk:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(
                _msgController.messages[i].date!))
      ]);
    }

    try {
      if (Platform.isAndroid) {
        directory = (await getExternalStorageDirectory())!;
      }
      if (await directory.exists()) {
        print(directory.path);
        String csvData = ListToCsvConverter().convert(csvContent);
        File savedFile =
            File(directory.path + "/${_msgController.messages[0].address}.csv");
        myfilepath = savedFile.path;
        await savedFile.writeAsString(csvData);
        shareFile();
      }
    } catch (e) {
      print(e);
    }
  }

  shareFile() async {
    await FlutterShare.shareFile(
      title: "Scraped Results",
      filePath: myfilepath,
    );
  }
}
