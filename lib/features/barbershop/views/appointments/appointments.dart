import 'package:flutter/material.dart';

class BarbershopAppointments extends StatelessWidget {
  const BarbershopAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(),
        ),
      ),
    );
  }
}
