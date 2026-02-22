import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warehouse/components/colored_button.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const double DEFAULT_SPACE = 12;
const double DEFAULT_LARGE_SPACE = 20;
const double SPACE_SMALL = 4;

SizedBox addHorizontalSpace([double width = DEFAULT_SPACE]) {
  return SizedBox(width: width);
}

SizedBox addVerticalSpace([double height = DEFAULT_SPACE]) {
  return SizedBox(height: height);
}


bool isPortrait(BuildContext context){ 
  return MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;
}

bool isLandscape(BuildContext context){
  return MediaQuery.of(context).size.width <= MediaQuery.of(context).size.height;
  
}


showAlert(
  BuildContext context,
  String title,
  String message, {
  bool isError = false,
  bool isDismissible = true,
  VoidCallback? onDismiss,
}) {
  showDialog(
    context: context,
    barrierDismissible: isDismissible,
    builder: (builder) {
      var color = isError ? COLOR_BASE_ERROR : COLOR_BASE_SUCCESS;
      VoidCallback myFunc;
      if (onDismiss != null) {
        myFunc = onDismiss;
      } else {
        myFunc = () => Navigator.pop(context);
      }

      return AlertDialog(
        title: Text(title, style: TextStyle(color: color)),
        content: Text(message, style: TextStyle(color: color)),
        actions: <Widget>[
          ColoredButton(
            onPressed: myFunc,
            child: Text('OK', style: TextStyle(color: COLOR_BASE)),
          ),
        ],
      );
    },
  );
}

String formatNumber(num number) {
  if (number < 1000) {
    return number.toString();
  } else if (number < 1000000) {
    double result = number / 1000;
    return result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1) +
        'K';
  } else if (number < 1000000000) {
    double result = number / 1000000;
    return result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1) +
        'M';
  } else {
    double result = number / 1000000000;
    return result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1) +
        'B';
  }
}

String standardDate(
  String isoTimestamp, {
  Duration timezoneOffset = const Duration(hours: 5, minutes: 30),
  String format = 'EEE hh:mm a yyyy MMM dd'
}) {
  DateTime dateTime = DateTime.parse(isoTimestamp);
  dateTime = dateTime.add(timezoneOffset);
  final DateFormat formatter = DateFormat(format);
  return formatter.format(dateTime);
}

String timeAgo(String isoTimestamp, {Duration timezoneOffset = const Duration(hours: 5, minutes: 30)}) {
  DateTime dateTime = DateTime.parse(isoTimestamp);

  if (timezoneOffset != null) {
    dateTime = dateTime.toUtc().add(timezoneOffset);
  } 

  final now = DateTime.now().toUtc();
  final diff = now.difference(dateTime);

  if (diff.isNegative) return "in the future";

  final seconds = diff.inSeconds;
  final minutes = diff.inMinutes;
  final hours = diff.inHours;
  final days = diff.inDays;

  if (seconds < 60) {
    return seconds <= 5 ? "just now" : "$seconds secs ago";
  } else if (minutes < 60) {
    return minutes == 1 ? "1 min ago" : "$minutes mins ago";
  } else if (hours < 24) {
    return hours == 1 ? "1 hour ago" : "$hours hours ago";
  } else if (days < 7) {
    return days == 1 ? "1 day ago" : "$days days ago";
  } else if (days < 30) {
    final weeks = (days / 7).floor();
    return weeks == 1 ? "1 week ago" : "$weeks weeks ago";
  } else if (days < 365) {
    final months = (days / 30).floor();
    return months == 1 ? "1 month ago" : "$months months ago";
  } else {
    final years = (days / 365).floor();
    return years == 1 ? "1 year ago" : "$years years ago";
  }
}

Future<File?> getLocalImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);

  return pickedFile != null ? File(pickedFile.path) : null;
}

Future<String> fileToBase64(File file) async {
  String base64 = await file.readAsBytes().then((bytes) => base64Encode(bytes));
  return base64;
}

Future<String> getScanValue() async {
  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    "#fff666",
    "Cancel",
    true,
    ScanMode.DEFAULT,
  );
  if (barcodeScanRes != "-1") {
    return barcodeScanRes;
    // showAlert(context, 'Details', barcodeScanRes);
  }

  return "";
}

Future<File> base64ToPdf(String base64String, String fileName) async {
  // Remove metadata if present
  final cleanBase64 = base64String.contains(',')
      ? base64String.split(',').last
      : base64String;

  final bytes = base64Decode(cleanBase64);

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName.pdf');

  await file.writeAsBytes(bytes, flush: true);
  return file;
}

void openPdf(File file) {
  OpenFilex.open(file.path);
}

String getFileName(File file) {
  final filePath = file.absolute.path;
  String fileName = filePath.split(Platform.pathSeparator).last;
  return fileName;
}

filterItemBy(List _order_list, String value) {
  if (value == "") {
    return _order_list;
  }
  return _order_list.where((order) {
    return ('${order['custumer_name']}'.toLowerCase()).contains(
          value.toLowerCase(),
        ) ||
        ('${order['tracking_id']}'.toLowerCase()).contains(value.toLowerCase()) ||
        ('${order['delivery_partener']}'.toLowerCase()).contains(
          value.toLowerCase(),
        ) ||
        ('${order['sku_name']}'.toLowerCase()).contains(value.toLowerCase()) ||
        ('${order['actual_status']}'.toLowerCase()).contains(value.toLowerCase()) ||
        ('${order['order_number']}'.toLowerCase()).contains(value.toLowerCase()) ||
        ('${order['product_name']}'.toLowerCase()).contains(value.toLowerCase());
  }).toList();
}

Future<File?> pickCSV() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );

  if (result == null) {
    // User canceled file picking
    return null;
  }

  final PlatformFile file = result.files.first;

  return File(file.path!);
}


showApiError(context){
  showAlert(context, 'Alert!', 'Network/Service not responed');
}
