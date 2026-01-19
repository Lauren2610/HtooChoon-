import 'package:flutter/material.dart';

class ApexUserHome extends StatefulWidget {
  final String role;
  const ApexUserHome({super.key, required this.role});

  @override
  State<ApexUserHome> createState() => _ApexUserHomeState();
}

class _ApexUserHomeState extends State<ApexUserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ApexUserHome")),
      body: SafeArea(child: Column(children: [])),
    );
  }
}
