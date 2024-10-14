import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
class SplashPage extends GetView<AppController> {
  const SplashPage({Key? key}) : super(key: key);
  static const String routeName ="/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/logos/ema_horizontal.svg",
                color: Get.theme.colorScheme.primary,
                height: 100,
              ),
              space2,
              SizedBox(width: 100,child: LinearProgressIndicator(color: Get.theme.primaryColor,backgroundColor: Colors.transparent,),)
            ],
          ),
        ],
      ),
    );
  }
}
