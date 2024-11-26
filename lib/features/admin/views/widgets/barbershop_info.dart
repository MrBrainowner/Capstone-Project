import 'package:barbermate/features/auth/models/barbershop_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/admin_controller.dart';

class BarbershopDetailPage extends StatelessWidget {
  final String barbershopId;
  final String barbershopName;
  final String status;
  final String recipientEmail;
  final BarbershopModel barbershop;

  const BarbershopDetailPage({
    super.key,
    required this.barbershopId,
    required this.status,
    required this.barbershopName,
    required this.recipientEmail,
    required this.barbershop,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

    // Fetch documents when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDocuments(barbershopId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barbershop Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section as Row
              Row(
                children: [
                  Obx(() {
                    // Debug print
                    // print('Profile Image URL: $profileImageUrl');

                    return CircleAvatar(
                      backgroundImage: NetworkImage(
                          barbershop.profileImage), // Fallback image
                      radius: 50.0,
                    );
                  }),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barbershopName,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8.0),
                        Text('Status: $status'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Status action buttons
              if (status == 'pending')
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final confirm =
                              await _showConfirmationDialog(context, 'approve');
                          if (confirm) {
                            controller.updateStatus(barbershopId, 'approved');

                            Get.back();
                          }
                        },
                        child: const Text('Approve'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final confirm =
                              await _showConfirmationDialog(context, 'reject');
                          if (confirm) {
                            controller.updateStatus(barbershopId, 'rejected');
                            Get.back();
                          }
                        },
                        child: const Text('Reject'),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),

              // ListTile for each document type based on available documents
              Obx(() {
                return Column(
                  children: controller.documents.keys.map((documentId) {
                    final documentUrl = controller.documents[documentId];
                    final iconData = documentUrl != null
                        ? (documentUrl.endsWith('.pdf')
                            ? Icons.picture_as_pdf
                            : Icons.image)
                        : Icons.warning;
                    final iconColor =
                        documentUrl != null ? Colors.blue : Colors.red;

                    return ListTile(
                      leading: Icon(iconData, color: iconColor),
                      title:
                          Text(documentId.replaceAll('_', ' ').toUpperCase()),
                      subtitle: Text(documentUrl != null
                          ? 'Tap to view'
                          : 'No documents available'),
                      trailing: documentUrl != null
                          ? IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () {
                                _launchURL(documentUrl);
                              },
                            )
                          : null,
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String action) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text('Are you sure you want to $action this barbershop?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text(action[0].toUpperCase() + action.substring(1)),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  void _launchURL(String url) async {
    final Logger logger = Logger();
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      logger.e('Could not launch $url');
    }
  }
}
