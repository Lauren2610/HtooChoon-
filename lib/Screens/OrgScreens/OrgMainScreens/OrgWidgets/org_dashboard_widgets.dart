import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';

void showCreateProgramDialog(BuildContext context, OrgProvider provider) {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width > 600
              ? 500
              : double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            // Required for TextFields inside Dialog
            color: Colors.transparent,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Create New Program",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Group your courses into a high-level program like 'Pre-GED' or 'Computer Science'.",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Program Name Field
                  Text(
                    "Program Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    validator: (v) => v!.isEmpty ? "Name is required" : null,
                    decoration: const InputDecoration(
                      hintText: "e.g. Computer Science Department",
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description Field
                  Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "What is this program about?",
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Actions
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            await provider.createProgram(
                              nameController.text,
                              descController.text,
                            );
                            print("calling");
                            if (provider.isLoading) {
                              CircularProgressIndicator();
                            } else {
                              if (context.mounted) Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Program created successfully!",
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            // Handle error
                          }
                        }
                      },
                      child: provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Create Program",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: child,
        ),
      );
    },
  );
}
