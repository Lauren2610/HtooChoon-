import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Constants/text_constants.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';

class PlanSelectionScreen extends StatefulWidget {
  final String role;
  const PlanSelectionScreen({super.key, required this.role});

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),

          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PlanCard(
                            cardColor: Theme.of(
                              context,
                            ).colorScheme.inversePrimary,
                            bulletColor: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(
                              context,
                            ).colorScheme.inversePrimary,
                          ),
                          PlanCard(
                            cardColor: Theme.of(context).colorScheme.secondary,
                            bulletColor: Theme.of(context).colorScheme.tertiary,
                            textColor: Theme.of(
                              context,
                            ).colorScheme.inversePrimary,
                          ),
                          PlanCard(
                            cardColor: Theme.of(
                              context,
                            ).colorScheme.inversePrimary,
                            bulletColor: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(
                              context,
                            ).colorScheme.inversePrimary,
                          ),
                        ],
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
  }
}

class PlanCard extends StatelessWidget {
  Color? cardColor = Colors.white;
  Color? bulletColor;
  Color? textColor;

  PlanCard({
    super.key,
    required this.cardColor,
    required this.bulletColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 20),
      height: 400,

      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Hyper",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Text("\$61", style: tLargeMoneyFont),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "no limit 20+ blablabla better than free plan",

                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "no limit 20+ blablabla better than free plan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "no limit 20+ blablabla better than free plan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
