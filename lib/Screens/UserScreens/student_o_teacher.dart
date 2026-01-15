import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/StudentScreens/free_student_home.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/TeacherScreens/free_teacher_home.dart';

class StudentORTeacherPage extends StatelessWidget {
  const StudentORTeacherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StudentOTeacherCard(
              text: 'student',
              icon: Icons.person,
              ontap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FreeStudentHome()),
                );
              },
            ),
            StudentOTeacherCard(
              text: 'teacher',
              icon: Icons.school,
              ontap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FreeTeacherHome()),
                );
              },
            ),
          ],
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
