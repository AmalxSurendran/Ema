import 'package:ema_v4/pages/forgot_password/forgot_password_page.dart';
import 'package:ema_v4/pages/login/controller/login_controller.dart';
import 'package:flutter/material.dart';

import '../../../constants/ui/spacing.dart';
import 'package:get/get.dart';
import 'package:ema_v4/constants/strings.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({Key? key, required this.controller}) : super(key: key);
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "login.title".c,
          style: Get.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        space1,
        Text("login.subtitle".c, style: Get.textTheme.titleMedium),
        space4,
        Text("login.input1".c,
            style:
                Get.textTheme.bodyLarge?.copyWith(color: Get.theme.hintColor)),
        space1,
        TextField(
          controller: controller.input1Controller,
          style: Get.textTheme.titleMedium,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "login.input1.hint".c,
          ),
          textInputAction: TextInputAction.next,
        ),
        space2,
        Text("login.input2".c,
            style:
                Get.textTheme.bodyLarge?.copyWith(color: Get.theme.hintColor)),
        space1,
        Obx(
          () => TextField(
            controller: controller.input2Controller,
            style: Get.textTheme.titleMedium,
            obscureText: controller.pwdHidden.value,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              hintText: "login.input2.hint".c,
              suffixIcon: GestureDetector(
                onTap: () => controller.togglePwdHidden(),
                child: Icon(controller.pwdHidden.isTrue
                    ? Icons.visibility
                    : Icons.visibility_off,color: Get.theme.primaryColor,),
              ),
            ),
            textInputAction: TextInputAction.done,
          ),
        ),
        space1,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () async {
                Get.toNamed(ForgotPasswordPage.routeName);
              },
              child: Text(
                "forgotPassword.title".c,
                style: Get.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
        space2,
        Obx(
          () => ElevatedButton(
            onPressed: () {
              if (!controller.loading.value) {
                controller.login();
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
                : Text("login.button".c),
          ),
        ),
        space2,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                controller.invitationMode.value = true;
              },
              child: Text(
                "invite.toggle.button".c,
                style: Get.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
