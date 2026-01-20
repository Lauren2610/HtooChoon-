import 'package:flutter/material.dart';

class OrgProvider extends ChangeNotifier {
  bool isDisposed = false;

  //TODO create courses like edx (DRAFT → READY → LIVE → COMPLETED → ARCHIVED) but only live learning sessions and recordings

  //TODO create programs (GED/ CS) / courses then classes

  //TODO request teachers to work on their orgnisaton

  //TODO invite students to study in their orgnisaton or accept the request to be their students

  //TODO to make the  a exam form

  //TODO create live learning sessions for students and teachers which include CV/AI from hugging face model cheat detection by expression /looking at phone/ tab moves (admin can turn on and turn off cheat detection during class since students might need to check pdf files or find something in google)

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
