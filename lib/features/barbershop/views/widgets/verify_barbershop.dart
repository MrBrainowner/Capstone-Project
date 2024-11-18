import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/verification_controller/verification_controller.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class VerifyBarbershop extends StatelessWidget {
  const VerifyBarbershop({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationController());
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
              // Use Obx here to only rebuild the ListView when the observable changes
              Obx(() {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.requiredDocumentTypes.length,
                    itemBuilder: (context, index) {
                      final documentType =
                          controller.requiredDocumentTypes[index];
                      final selectedFile =
                          controller.selectedFiles[documentType];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(
                              documentType.replaceAll('_', ' ').toUpperCase()),
                          subtitle: selectedFile == null
                              ? const Text('No file selected')
                              : Text(
                                  'Selected: ${selectedFile.path.split('/').last}'),
                          trailing: IconButton(
                            icon: const iconoir.Attachment(),
                            onPressed: () {
                              controller.pickFile(documentType);
                            },
                          ),
                          leading: selectedFile == null
                              ? const iconoir.Page()
                              : IconButton(
                                  icon: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                  onPressed: () {},
                                ),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),
              // The Submit Button does not need to be wrapped in Obx as it is not dependent on observable variables
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submitFiles,
                  child: const Text('Submit All Documents'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
