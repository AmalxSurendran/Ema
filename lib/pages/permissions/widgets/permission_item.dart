import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PermissionItem extends StatelessWidget {
  const PermissionItem(
      {Key? key,
      required this.headingString,
      required this.descriptionString,
      required this.assetPath, required this.identifier,
      })
      : super(key: key);
  final String headingString, descriptionString, assetPath,identifier;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headingString.c,
            style: Get.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          space2,
          AspectRatio(
            aspectRatio: 1,
            child: SvgPicture.asset(
              assetPath,
            ),
          ),
          space2,
          Text(
            descriptionString.c,
            style:
                Get.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
