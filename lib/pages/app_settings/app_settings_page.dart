import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:ema_v4/pages/app_settings/widgets/biometric_card.dart';
import 'package:ema_v4/pages/app_settings/widgets/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_settings_page_controller.dart';

class AppSettingsPage extends GetView<AppSettingsPageController> {
  const AppSettingsPage({Key? key}) : super(key: key);
  static const String routeName = '/appSettings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: pagePadding,
          child: Column(
            children: [
              ThemeSettingCard(),
              space2,
              const BiometricSettingCard(),
            ],
          ),
        ),
      ),
    );
  }
}
