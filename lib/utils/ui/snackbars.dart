import 'package:ema_v4/constants/colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

showSuccessSnackbar(String message,
    {Duration duration = const Duration(seconds: 3)}) {
  Get.showSnackbar(
    GetSnackBar(
      backgroundColor: themeGreen,
      duration: duration,
      messageText: Text(
        message,
        style: Get.theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
    ),
  );
}

showWarningSnackbar(String message,
    {Duration duration = const Duration(seconds: 3)}) {
  Get.showSnackbar(
    GetSnackBar(
      backgroundColor: themeYellow,
      duration: duration,
      messageText: Text(
        message,
        style: Get.theme.textTheme.bodyMedium?.copyWith(color: Colors.black),
      ),
    ),
  );
}

showErrorSnackbar(String message,
    {Duration duration = const Duration(seconds: 3)}) {
  Get.showSnackbar(
    GetSnackBar(
      backgroundColor: themeRed,
      duration: duration,
      messageText: Text(
        message,
        style: Get.theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
    ),
  );
}
