import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static void createToastMessage() {
    Fluttertoast.showToast(msg: "hej");
  }
}
