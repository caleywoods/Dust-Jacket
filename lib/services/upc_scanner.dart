import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
// For fetching random test book
// import 'dart:math';

class UPCScanner {

  static Future<String> scan() async {
    try {
      // final _random = new Random();
      // var thumbnail_failure_barcode = '9780545069670';
      // var llama_llama = '9780451474575';
      // Testing barcode for Junie B Jones Loves Handsome Warren
      // List<String> test_barcodes = ['9780596003067', '0439188830', '9781338290912', '9780062404404','9780062404404','9780698138551', '9780670012336', '9780451474575', '9780062675262', '9780062404381', '9781536428995', '9781338611984', '9781338290943', '9780545069670', '9781781100509', '9780545582957', '9780439136358'];
      // List<String> test_barcodes = ['9781328684011', '9781338250978'];
      String barcode = await BarcodeScanner.scan();
      return barcode;
      // return test_barcodes[_random.nextInt(test_barcodes.length)];
      // return thumbnail_failure_barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        return 'The user did not grant the camera permission!';
      } else {
        return 'Unknown error: $e';
      }
    } on FormatException {
        return 'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      return e;
    }
  }
}