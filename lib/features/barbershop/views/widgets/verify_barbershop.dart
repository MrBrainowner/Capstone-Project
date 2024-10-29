import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/verification_controller/verification_controller.dart';

class VerifyBarbershop extends StatelessWidget {
  const VerifyBarbershop({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationController());
    final documentTypes = [
      'business_registration',
      'barangay_clearance',
      'mayors_permit',
      'fire_safety_certificate',
      'sanitation_permit',
      'proof_of_address',
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text('Verify Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload your business documents:',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              // Use ExpansionTile for each document
              for (final documentType in documentTypes) ...[
                Obx(() {
                  final file = controller.selectedFiles[documentType];
                  return ExpansionTile(
                    leading: file != null
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.upload_file),
                    title: Text(
                      documentType.replaceAll('_', ' ').capitalize!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  controller.pickFile(documentType),
                              child: Text(
                                  'Upload ${documentType.replaceAll('_', ' ').capitalize}'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        file != null
                            ? 'Selected: ${file.path.split('/').last}'
                            : 'No file selected',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
                const SizedBox(height: 8),
              ],

              // Submit Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Upload all selected files
                        controller.submitFiles();
                      },
                      child: const Text('Submit All Files'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
