import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:ema_v4/controllers/app_controller.dart';
import 'package:ema_v4/controllers/auth_controller.dart';
import 'package:ema_v4/pages/faq/faq_page.dart';
import 'package:ema_v4/pages/feedback/feedback_page.dart';
import 'package:ema_v4/pages/update_profile/update_profile_page.dart';
import 'package:ema_v4/utils/ui/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../about/about_page.dart';
import '../../app_settings/app_settings_page.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key}) : super(key: key);

  final AppController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Get.theme.colorScheme.primaryContainer),
          padding: allPad2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset(
                'assets/logos/ema_horizontal.svg',
                color: Get.theme.colorScheme.onPrimaryContainer,
                alignment: Alignment.centerLeft,
                height: 36.0,
              ),
              const Spacer(),
              Text(
                "${ac.patient.name.given} ${ac.patient.name.family ?? ''}",
                style: Get.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Get.theme.colorScheme.onPrimaryContainer),
              ),
              space1,
              Text(
                Get.find<AppController>().patient.telecom.email ?? '',
                style: Get.theme.textTheme.bodyMedium
                    ?.copyWith(color: Get.theme.colorScheme.onPrimaryContainer),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(0.0),
            children: [
              ListTile(
                onTap: () => _onItemClicked(AboutPage.routeName, null),
                leading: const Icon(Icons.info),
                title: Text(
                  'About EMA',
                  style: Get.theme.textTheme.titleMedium,
                ),
                iconColor: Get.theme.colorScheme.primary,
                horizontalTitleGap: 0.0,
              ),
              ListTile(
                onTap: () => _onItemClicked(FeedbackPage.routeName, null),
                leading: const Icon(Icons.feedback),
                title: Text(
                  'Feedback',
                  style: Get.theme.textTheme.titleMedium,
                ),
                iconColor: Get.theme.colorScheme.primary,
                horizontalTitleGap: 0.0,
              ),
              ListTile(
                onTap: () => _onItemClicked(FAQPage.routeName, null),
                leading: const Icon(Icons.help),
                title: Text(
                  'FAQ',
                  style: Get.theme.textTheme.titleMedium,
                ),
                iconColor: Get.theme.colorScheme.primary,
                horizontalTitleGap: 0.0,
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Settings',
                  style: Get.theme.textTheme.bodySmall
                      ?.copyWith(color: Get.theme.colorScheme.secondary),
                ),
              ),
              space1,
              ListTile(
                onTap: () => _onItemClicked(AppSettingsPage.routeName, null),
                leading: const Icon(Icons.settings),
                title: Text(
                  'App settings',
                  style: Get.theme.textTheme.titleMedium,
                ),
                iconColor: Get.theme.colorScheme.primary,
                horizontalTitleGap: 0.0,
              ),
              ListTile(
                onTap: () => _onItemClicked(UpdateProfilePage.routeName, null),
                leading: const Icon(Icons.account_circle),
                title: Text(
                  'Profile settings',
                  style: Get.theme.textTheme.titleMedium,
                ),
                iconColor: Get.theme.colorScheme.primary,
                horizontalTitleGap: 0.0,
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Account',
                  style: Get.theme.textTheme.bodySmall
                      ?.copyWith(color: Get.theme.colorScheme.secondary),
                ),
              ),
              space1,
              ListTile(
                onTap: _onLogoutClicked,
                leading: const Icon(Icons.power_settings_new),
                title: Text(
                  'Logout',
                  style: Get.theme.textTheme.titleMedium,
                ),
                iconColor: Get.theme.colorScheme.primary,
                horizontalTitleGap: 0.0,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  _onItemClicked(String route, dynamic args) {
    Get.back();
    Get.toNamed(route, arguments: args);
  }

  _onLogoutClicked() {
    showCustomDialog(
      title: "Confirmation",
      description: "Are you sure to logout?",
      confirmText: "Yes",
      cancelText: "No",
      onConfirm: () {
        Get.find<AuthController>().logout();
      }
    );
  }
}
