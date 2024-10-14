import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/ui/spacing.dart';
import 'update_profile_page_controller.dart';

class UpdateProfilePage extends GetView<UpdateProfilePageController> {
  const UpdateProfilePage({Key? key}) : super(key: key);
  static const String routeName = '/updateProfile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update profile'),
        actions: [
          if (Navigator.of(context).canPop()) ...[
            IconButton(
              onPressed: controller.onEditSaveClick,
              icon: Obx(
                () => controller.editing.isFalse
                    ? const Icon(Icons.edit)
                    : const Icon(Icons.check),
              ),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              space4,
              Text(
                'Height (in centimeter)',
                style: Get.theme.textTheme.bodyMedium
                    ?.copyWith(color: Get.theme.colorScheme.secondary),
              ),
              space1,
              Obx(
                () => TextField(
                  decoration: const InputDecoration(suffixText: 'cm', hintText: 'e.g. 162'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: controller.heightInputController,
                  readOnly: controller.editing.isFalse,
                  focusNode: controller.heightFocusNode,
                ),
              ),
              space4,
              Text(
                'Weight (in kilograms)',
                style: Get.theme.textTheme.bodyMedium
                    ?.copyWith(color: Get.theme.colorScheme.secondary),
              ),
              space1,
              Obx(
                () => TextField(
                  decoration: const InputDecoration(suffixText: 'kg', hintText: 'e.g. 65.5'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  controller: controller.weightInputController,
                  readOnly: controller.editing.isFalse,
                ),
              ),
              if (!Navigator.of(context).canPop()) ...[
                space4,
                ElevatedButton(
                  onPressed: controller.onEditSaveClick,
                  child: const Text('Submit'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
