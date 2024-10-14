import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:ema_v4/pages/forgot_password/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  const ForgotPasswordPage({Key? key}) : super(key: key);
  static const String routeName = "/forgotPassword";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: pagePadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              space4,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/logos/ema_horizontal.svg",
                    color: Get.theme.colorScheme.primary,
                    height: 70,
                  ),
                ],
              ),
              space2,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "forgotPassword.title".c,
                    style: Get.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  space1,
                  Text("forgotPassword.subtitle".c, style: Get.textTheme.titleMedium),
                  space4,
                  Text("forgotPassword.input1".c,
                      style:
                      Get.textTheme.bodyLarge?.copyWith(color: Get.theme.hintColor)),
                  space1,
                  TextField(
                    controller: controller.input1Controller,
                    style: Get.textTheme.titleMedium,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "forgotPassword.input1.hint".c,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  space2,
                  Text("forgotPassword.input2".c,
                      style:
                      Get.textTheme.bodyLarge?.copyWith(color: Get.theme.hintColor)),
                  space1,
                  TextField(
                      controller: controller.input2Controller,
                      style: Get.textTheme.titleMedium,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "forgotPassword.input2.hint".c,
                    ),
                      textInputAction: TextInputAction.done,
                    ),

                  space4,
                  Obx(
                        () => ElevatedButton(
                      onPressed: () {
                        if (!controller.loading.value) {
                          controller.requestPasswordReset();
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
                          : Text("forgotPassword.button".c),
                    ),
                  ),
                  space2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          "forgotPassword.back.button".c,
                          style: Get.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
