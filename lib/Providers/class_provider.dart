import 'package:flutter/material.dart';

class ClassProvider extends ChangeNotifier {
  bool isDisposed = false;

  void safeChangeNotifier() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
