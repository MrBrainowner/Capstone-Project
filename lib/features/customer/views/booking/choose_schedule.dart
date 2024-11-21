import 'package:flutter/material.dart';

class ChooseSchedule extends StatelessWidget {
  const ChooseSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Choose Schedule',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
