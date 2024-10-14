import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/permissions_controller.dart';

class PermissionsPage extends GetView<PermissionsPageController> {
  const PermissionsPage({Key? key}) : super(key: key);
  static const String routeName = "/permissions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: pagePadding,
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => controller.buttonText.value.isNotEmpty
                      ? PageView(
                          controller: controller.pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: controller.pageItems,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              space2,
              ElevatedButton(
                  onPressed: () {
                    controller.onButtonTap();
                  },
                  child: Obx(() => Text(controller.buttonText().c))),
              Obx(
                () => controller.skipButtonText.value.isNotEmpty
                    ? Column(
                        children: [
                          space1,
                          TextButton(
                              onPressed: () {
                                controller.moveToNextPage();
                              },
                              child: Obx(
                                  () => Text(controller.skipButtonText().c))),
                          space1,
                          InkWell(onTap:(){
                            controller.neverAskMoveToNextPage();
                          },child: Text("permissions.page.never.ask".c))
                        ],
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
