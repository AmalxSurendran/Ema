import 'package:ema_v4/pages/login/controller/login_controller.dart';
import 'package:ema_v4/pages/login/widgets/invite_widget.dart';
import 'package:ema_v4/pages/login/widgets/login_widget.dart';
import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = "/login";
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
              Obx(() =>controller.invitationMode.value
                  ? InviteFormWidget(
                  key: const Key("invite"), controller: controller)
                  : LoginFormWidget(
                  key: const Key("login"), controller: controller),
              )
            ],
          ),
        ),
      ),
    );
  }
}
