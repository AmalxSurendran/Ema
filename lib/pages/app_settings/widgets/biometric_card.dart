import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_settings_page_controller.dart';

class BiometricSettingCard extends GetView<AppSettingsPageController> {
  const BiometricSettingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: allPad2,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'permissions.page.biometric.heading'.c,
                    style: Get.theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                horSpace1,
                Obx(
                  () => Switch(
                    value: controller.biometricEnabled.value,
                    onChanged: controller.onBiometricSwitchToggle,
                  ),
                ),
              ],
            ),
            space1,
            Text(
              'permissions.page.biometric.desc'.c,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Get.theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
