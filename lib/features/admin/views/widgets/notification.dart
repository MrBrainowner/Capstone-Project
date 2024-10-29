import 'package:flutter/material.dart';

class AdminNotifications extends StatelessWidget {
  const AdminNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount:
            10, // Replace with dynamic count from your notifications source
        itemBuilder: (context, index) {
          return _buildNotificationCard(
            context,
            'New Barbershop Registered',
            'A new barbershop has been registered: Classic Cuts. Check it out and review its details.',
            Icons.business,
            Colors.green,
            '10 mins ago',
          );
        },
      ),
    );
  }

  // Notification Card
  Widget _buildNotificationCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    String time,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, size: 30.0, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              time,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.blue),
          onPressed: () {
            // Handle view details action
          },
        ),
      ),
    );
  }
}
