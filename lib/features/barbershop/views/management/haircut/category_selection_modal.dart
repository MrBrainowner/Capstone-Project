import 'package:barbermate/common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorySelectionController extends GetxController {
  static CategorySelectionController get intance => Get.find();

  var availableCategories = [
    // Short Haircuts
    'Buzz Cut', // Includes all short, close-shaven cuts
    'Crew Cut', // Classic, military-inspired cut
    'Ivy League', // Similar to crew cut but slightly longer on top

    // Medium-Length Styles
    'Pompadour', // High-volume styles, including modern variations
    'Quiff', // Front-focused, styled up or back
    'Undercut', // Longer on top with shaved or short sides
    'Textured Crop', // Messy or layered crop styles
    'Fringe', // Includes cuts with bangs or fringe
    'Side Part', // Classic side-parted styles, including comb-over and slicked styles
    'Tapered Cuts', // Gradual shortening on the sides, less drastic than fades

    // Curly, Wavy, and Afro Styles
    'Wavy Styles', // Natural wavy or curly haircuts
    'Afro', // Afro-centric styles for natural hair
    'Curly Haircuts', // Curls styled short, medium, or long

    // Edgy and Trendy Styles
    'Mohawk', // Tall strip in the center with shaved sides
    'Faux Hawk', // Shorter, modern version of the mohawk
    'Comb Over', // Side-parted style, often with a fade or undercut

    // Slicked and Swept Styles
    'Swept-Back', // Slicked back or combed-back styles, includes gelled looks
  ].obs;

  var selectedCategories = <String>[].obs;

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      if (selectedCategories.length < 3) {
        selectedCategories.add(category);
      } else {
        ToastNotif(
                message: 'You can only select up to 3 categories.',
                title: 'Limit Reached')
            .showWarningNotif(Get.context);
      }
    }
  }

  void confirmSelection() {
    Get.back(result: selectedCategories);
  }
}

class CategorySelectionBottomSheet extends StatelessWidget {
  const CategorySelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final CategorySelectionController controller =
        Get.put(CategorySelectionController());

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Categories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          // Scrollable List of Choice Chips
          Expanded(
            child: Obx(() {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8.0, // Horizontal space between chips
                  runSpacing: 8.0, // Vertical space between lines
                  children: controller.availableCategories
                      .map((category) => ChoiceChip(
                            label: Text(category),
                            selected: controller.selectedCategories
                                .contains(category),
                            onSelected: (isSelected) =>
                                controller.toggleCategory(category),
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            backgroundColor:
                                Theme.of(context).chipTheme.backgroundColor,
                            labelStyle: TextStyle(
                              color: controller.selectedCategories
                                      .contains(category)
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                            ),
                          ))
                      .toList(),
                ),
              );
            }),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.confirmSelection,
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
