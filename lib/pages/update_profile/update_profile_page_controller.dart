import 'package:ema_v4/controllers/app_controller.dart';
import 'package:ema_v4/services/apiService.dart';
import 'package:ema_v4/utils/ui/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/api/request/update_self_user_request.dart';
import '../../utils/ui/snackbars.dart';
import '../home/home_page.dart';
import '../permissions/controller/permissions_controller.dart';
import '../permissions/permissions_page.dart';

class UpdateProfilePageController extends GetxController {
  AppController ac = Get.find();

  final TextEditingController heightInputController = TextEditingController();
  final TextEditingController weightInputController = TextEditingController();
  late FocusNode heightFocusNode;

  final RxBool editing = false.obs;

  @override
  void onInit() {

    heightFocusNode = FocusNode();

    heightInputController.text = ac.patient.height?.toString() ?? '';
    weightInputController.text = ac.patient.weight?.toString() ?? '';

    if (!Navigator.of(Get.context!).canPop()) {
      editing(true);
    }

    super.onInit();
  }

  onEditSaveClick() async {
    if (editing.isFalse) {
      editing(true);
      heightFocusNode.requestFocus();
    } else {

      if (_validateForm()) {

        showProgressDialog(message: 'Updating ...');

        bool? res = await ApiService().updateSelfUser(UpdateSelfUserRequest(
            height: double.parse(heightInputController.text),
            weight: double.parse(weightInputController.text)
        ));

        if (res != null) {
          ac.patient.height = double.parse(heightInputController.text);
          ac.patient.weight = double.parse(weightInputController.text);
          showSuccessSnackbar('Profile updated');
        }

        editing(false);

        dismissDialog();

        if (!Navigator.of(Get.context!).canPop()) {
          if (await PermissionsPageController.requiresAnyPermission()) {
            Get.offAllNamed(PermissionsPage.routeName);
          } else {
            Get.offAllNamed(HomePage.routeName);
          }
        }

      }

    }
  }

  bool _validateForm() {

    if (heightInputController.text == '') {

      showErrorSnackbar('Height is required');
      return false;

    }

    if (weightInputController.text == '') {

      showErrorSnackbar('Weight is required');
      return false;

    }

    try {
      double.parse(heightInputController.text);
      double.parse(weightInputController.text);
    } catch (e) {
      showErrorSnackbar('Invalid height or weight');
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    heightFocusNode.dispose();
    heightInputController.dispose();
    weightInputController.dispose();
    super.onClose();
  }
}
