import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
class UPCScanner {

  static Future<String> scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      return barcode;
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