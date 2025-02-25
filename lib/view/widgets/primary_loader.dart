import 'package:flutter/material.dart';

class PrimaryLoader extends StatelessWidget {
  const PrimaryLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
