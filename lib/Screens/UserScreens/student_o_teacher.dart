import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';

import 'package:htoochoon_flutter/Screens/UserScreens/free_user_home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentORTeacherPage extends StatefulWidget {
  const StudentORTeacherPage({Key? key}) : super(key: key);

  @override
  State<StudentORTeacherPage> createState() => _StudentORTeacherPageState();
}

class _StudentORTeacherPageState extends State<StudentORTeacherPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) => Scaffold(
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StudentOTeacherCard(
                text: 'student',
                icon: Icons.person,
                ontap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  String? userId = prefs.getString('userId');
                  if (userId != null) {
                    await loginProvider.updateUserType(
                      userId,
                      'student',
                    ); // or 'teacher'
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FreeUserHome()),
                  );
                },
              ),
              StudentOTeacherCard(
                text: 'teacher',
                icon: Icons.school,
                ontap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  String? userId = prefs.getString('userId');
                  if (userId != null) {
                    await loginProvider.updateUserType(
                      userId,
                      'teacher',
                    ); // or 'teacher'
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FreeUserHome()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentOTeacherCard extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final VoidCallback? ontap;
  StudentOTeacherCard({
    super.key,
    required this.text,
    required this.icon,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,

      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Icon(icon), Text(text.toString())],
          ),
        ),
      ),
    );
  }
}
