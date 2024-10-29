import 'package:flutter/material.dart';

class CustomerNotifications extends StatelessWidget {
  const CustomerNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 10, // Replace with dynamic count
        itemBuilder: (context, index) {
          return null;
        },
      ),
    );
  }
}
