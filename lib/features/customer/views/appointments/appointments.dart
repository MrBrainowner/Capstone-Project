import 'package:flutter/material.dart';

class CustomerAppointments extends StatelessWidget {
  const CustomerAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Appointments'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Upcoming Appointments
              const Text(
                'Upcoming Appointments',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildAppointmentList([
                _Appointment(
                    '2024-08-20 10:00 AM', 'The Classic Barber', 'Confirmed'),
                _Appointment('2024-08-22 2:00 PM', 'Modern Cuts', 'Pending'),
              ]),
              const SizedBox(height: 24.0),

              // Past Appointments
              const Text(
                'Past Appointments',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildAppointmentList([
                _Appointment('2024-07-15 1:00 PM', 'Urban Styles', 'Completed'),
                _Appointment(
                    '2024-07-10 3:00 PM', 'The Classic Barber', 'Completed'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(List<_Appointment> appointments) {
    return Column(
      children: appointments.map((appointment) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text(appointment.dateTime),
            subtitle: Text(appointment.barbershopName),
            trailing: _buildStatusIndicator(appointment.status),
            onTap: () {
              // Implement appointment details navigation or modal here
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color color;
    if (status == 'Confirmed') {
      color = Colors.green;
    } else if (status == 'Pending') {
      color = Colors.orange;
    } else if (status == 'Completed') {
      color = Colors.grey;
    } else {
      color = Colors.red;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Appointment {
  final String dateTime;
  final String barbershopName;
  final String status;

  _Appointment(this.dateTime, this.barbershopName, this.status);
}
