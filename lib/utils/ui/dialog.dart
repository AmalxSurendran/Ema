import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../constants/ui/shape.dart';
import '../../constants/ui/spacing.dart';

void showCustomDialog({
  required String title,
  required String description,
  Widget? descriptionWidget,
  required String confirmText,
  Function()? onConfirm,
  String? cancelText,
  Function()? onCancel,
  bool dismissible = false,
}) {
  Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(rad2),
        ),
        backgroundColor: Get.theme.cardColor,
        child: Padding(
          padding: allPad4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              space2,
              if (descriptionWidget == null)
                Text(description, style: Get.theme.textTheme.bodyMedium),
              if (descriptionWidget != null) descriptionWidget,
              space2,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (cancelText != null)
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          dismissDialog();
                          if (onCancel != null) {
                            onCancel();
                          }
                        },
                        child: Text(cancelText),
                      ),
                    ),
                  if (cancelText != null) horSpace1,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        dismissDialog();
                        if (onConfirm != null) {
                          onConfirm();
                        }
                      },
                      child: Text(confirmText),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: dismissible);
}

showProgressDialog({required String message, bool dismissible = false}) {
  Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(rad2),
        ),
        backgroundColor: Get.theme.cardColor,
        child: Padding(
          padding: allPad4,
          child: Row(
            children: [
              const CircularProgressIndicator(),
              horSpace4,
              Text(message),
            ],
          ),
        ),
      ),
      barrierDismissible: dismissible);
}

dismissDialog() {
  Get.until((route) => !Get.isDialogOpen!);
}
