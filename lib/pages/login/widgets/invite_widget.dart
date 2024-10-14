import 'package:flutter/material.dart';

import '../../../constants/ui/spacing.dart';
import 'package:get/get.dart';
import 'package:ema_v4/constants/strings.dart';

import '../controller/login_controller.dart';

class InviteFormWidget extends StatelessWidget {
  const InviteFormWidget({Key? key, required this.controller})
      : super(key: key);
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "invite.title".c,
          style: Get.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        space1,
        Obx(() => Text(
            controller.authController.autoInviteCode.value != null
                ? "invite.subtitle.auto".c
                : "invite.subtitle".c,
            style: Get.textTheme.titleMedium)),
        space4,
        Obx(
          () => Visibility(
            visible: controller.authController.autoInviteCode.value == null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("invite.input1".c,
                    style: Get.textTheme.bodyLarge
                        ?.copyWith(color: Get.theme.hintColor)),
                space1,
                TextField(
                  controller: controller.input1Controller,
                  style: Get.textTheme.titleMedium,
                  decoration: InputDecoration(
                    hintText: "invite.input1.hint".c,
                  ),
                  textInputAction: TextInputAction.next,
                ),
                space2,
              ],
            ),
          ),
        ),
        Text("invite.input2".c,
            style:
                Get.textTheme.bodyLarge?.copyWith(color: Get.theme.hintColor)),
        space1,
        TextField(
          controller: controller.input2Controller,
          keyboardType: TextInputType.number,
          style: Get.textTheme.titleMedium,
          decoration: InputDecoration(
            hintText: "invite.input2.hint".c,
          ),
          textInputAction: TextInputAction.next,
        ),
        space2,
        Text("invite.input3".c,
            style:
                Get.textTheme.bodyLarge?.copyWith(color: Get.theme.hintColor)),
        space1,
        Obx(
          () => TextField(
            controller: controller.input3Controller,
            style: Get.textTheme.titleMedium,
            obscureText: controller.invitePwdHidden.value,
            decoration: InputDecoration(
              hintText: "invite.input3.hint".c,
              suffixIcon: GestureDetector(
                onTap: () => controller.toggleInvitePwdHidden(),
                child: Icon(controller.invitePwdHidden.isTrue
                    ? Icons.visibility
                    : Icons.visibility_off,color: Get.theme.primaryColor),
              ),
            ),
            textInputAction: TextInputAction.next,
          ),
        ),
        space2,
        Text("invite.input4".c,
            style:
                Get.textTheme.bodyLarge?.copyWith(color: Get.theme.hintColor)),
        space1,
        Obx(
          () => TextField(
            controller: controller.input4Controller,
            style: Get.textTheme.titleMedium,
            obscureText: controller.invitePwdConfirmHidden.value,
            decoration: InputDecoration(
              hintText: "invite.input4.hint".c,
              suffixIcon: GestureDetector(
                onTap: () => controller.toggleInvitePwdConfirmHidden(),
                child: Icon(controller.invitePwdConfirmHidden.isTrue
                    ? Icons.visibility
                    : Icons.visibility_off,color: Get.theme.primaryColor),
              ),
            ),
            textInputAction: TextInputAction.done,
          ),
        ),
        space4,
        Obx(
          () => ElevatedButton(
            onPressed: () {
              if (!controller.loading.value) {
                controller.acceptInvite();
              }
            },
            child: controller.loading.value
                ? SizedBox(
                    height: Get.textTheme.titleLarge?.fontSize,
                    width: Get.textTheme.titleLarge?.fontSize,
                    child: CircularProgressIndicator(
                      color: Get.theme.cardColor,
                      strokeWidth: 2,
                    ),
                  )
                : Text("invite.button".c),
          ),
        ),
        space1,
        TextButton(
          onPressed: () {
            controller.invitationMode.value = false;
            controller.authController.autoInviteCode.value = null;
          },
          child: Obx(() => Text(
              controller.authController.autoInviteCode.value != null
                  ? "invite.back.button.auto".c
                  : "invite.back.button".c)),
        )
      ],
    );
  }
}
