// Flutter HomePage UI for "HtooChoon"
// Fixed version: Search bar + categories in one row (no layout errors)

import 'package:flutter/material.dart';

class FreeUserHome extends StatelessWidget {
  const FreeUserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("HtooChoon"),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "About Us",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Contact Us",
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(icon: const Icon(Icons.category), onPressed: () {}),
          IconButton(icon: const Icon(Icons.account_circle), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            // Search + Categories Row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 60,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          CategoryBox(title: "HTML"),
                          CategoryBox(title: "Python"),
                          CategoryBox(title: "AI"),
                          CategoryBox(title: "Figma"),
                          CategoryBox(title: "HTML"),
                          CategoryBox(title: "Python"),
                          CategoryBox(title: "AI"),
                          CategoryBox(title: "Figma"),
                          CategoryBox(title: "HTML"),
                          CategoryBox(title: "Python"),
                          CategoryBox(title: "AI"),
                          CategoryBox(title: "Figma"),
                          CategoryBox(title: "HTML"),
                          CategoryBox(title: "Python"),
                          CategoryBox(title: "AI"),
                          CategoryBox(title: "Figma"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search courses",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Your Online Classes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Online Classes Cards
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  ClassCard(
                    title: "Python Basics",
                    progress: 0.7,
                    status: "Live class tomorrow",
                  ),
                  ClassCard(
                    title: "HTML & CSS",
                    progress: 0.4,
                    status: "Homework pending",
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "News Feed",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // News Feed FROM API
            ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.school),
                    title: Text("New update from your course #${index + 1}"),
                    subtitle: const Text(
                      "Instructor posted new content or announcement.",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryBox extends StatelessWidget {
  final String title;

  const CategoryBox({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class ClassCard extends StatelessWidget {
  final String title;
  final double progress;
  final String status;

  const ClassCard({
    super.key,
    required this.title,
    required this.progress,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        margin: const EdgeInsets.only(right: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 8),
              Text("Progress: ${(progress * 100).toInt()}%"),
              const Spacer(),
              Text(status, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
