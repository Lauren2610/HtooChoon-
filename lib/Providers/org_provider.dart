import 'package:flutter/material.dart';

class OrgProvider extends ChangeNotifier {
  bool isDisposed = false;

  //TODO create courses like edx (live only)

  //TODO request teachers to work on their orgnisaton or the teacher's request to work in their org

  //TODO invite students to study in their orgnisaton or accept the request to be their students

  //TODO to make the  a exam form
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
