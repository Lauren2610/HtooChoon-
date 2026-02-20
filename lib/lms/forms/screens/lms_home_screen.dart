import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'form_builder_screen.dart';
import 'form_attempt_screen.dart';
import '../models/form_model.dart';

class LmsHomeScreen extends StatefulWidget {
  final String userId;
  final String userRole;
  final String classId;

  const LmsHomeScreen({
    Key? key,
    required this.userId,
    required this.userRole,
    required this.classId,
  }) : super(key: key);

  @override
  State<LmsHomeScreen> createState() => _LmsHomeScreenState();
}

class _LmsHomeScreenState extends State<LmsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.userRole == 'teacher')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    createTestOptionDialog(
                      context: context,
                      userId: widget.userId,
                    );
                  });
                },
              ),
            ),
          ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('forms')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final docs = snapshot.data?.docs ?? [];

              if (docs.isEmpty) {
                return const Center(child: Text('No forms available.'));
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final form = FormModel.fromFirestore(docs[index]);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: Icon(
                        form.type == FormType.test
                            ? Icons.timer
                            : Icons.assignment,
                      ),
                      title: Text(form.title),
                      subtitle: Text(
                        '${form.questions.length} Questions • ${form.totalMarks} Marks',
                      ),
                      trailing: widget.userRole == 'teacher'
                          ? IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FormBuilderScreen(
                                      formId: form.id,
                                      userId: widget.userId,
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Icon(Icons.chevron_right),
                      onTap: () {
                        if (widget.userRole == 'student') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormAttemptScreen(
                                formId: form.id,
                                studentId: widget.userId,
                                studentName: 'Student', // Mock name
                              ),
                            ),
                          );
                        } else {
                          // Teacher View Results or Preview
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormBuilderScreen(
                                formId: form.id,
                                userId: widget.userId,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

void createTestOptionDialog({
  required BuildContext context,
  required String userId,
}) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              glassButton(
                context: context,
                title: "Create Form",
                subtitle: "Create forms for tests and assignments",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormBuilderScreen(userId: userId),
                    ),
                  );
                },
              ),
              glassButton(
                context: context,
                title: "Create Game",
                subtitle:
                    "Create fun quiz games for enhance memorization and practice",
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget glassButton({
  required BuildContext context,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.1), // glass tint
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
