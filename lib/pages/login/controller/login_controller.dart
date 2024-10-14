import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/ui/snackbars.dart';

class LoginController extends GetxController {
  final AuthController authController = Get.find();
  final TextEditingController input1Controller = TextEditingController();
  final TextEditingController input2Controller = TextEditingController();
  final TextEditingController input3Controller = TextEditingController();
  final TextEditingController input4Controller = TextEditingController();
  final RxBool loading = RxBool(false);
  final RxBool pwdHidden = RxBool(true);
  final RxBool invitePwdHidden = RxBool(true);
  final RxBool invitePwdConfirmHidden = RxBool(true);
  RxBool invitationMode = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    authController.autoInviteCode.listen((p0) {
      if (p0 != null) {
        invitationMode.value = true;
      }
    });
    if (authController.autoInviteCode.value != null) {
      invitationMode.value = true;
    }
  }

  Future<void> login() async {
    if (input1Controller.text.isNotEmpty) {
      if (input2Controller.text.isNotEmpty) {
        loading.value = true;
        await authController.login(
            nhsId: input1Controller.text, password: input2Controller.text);
        loading.value = false;
      }
    }
  }

  Future<void> acceptInvite() async {
    if (input1Controller.text.isEmpty) {
      input1Controller.text = authController.autoInviteCode.value ?? "";
    }
    if (input1Controller.text.isNotEmpty) {
      if (input2Controller.text.isNotEmpty) {
        if (input3Controller.text.isNotEmpty) {
          if (input4Controller.text.isNotEmpty) {
            if (input3Controller.text == input4Controller.text) {
              if (validatePassword(input3Controller.text)) {
                loading.value = true;
                await authController.acceptInvite(
                    inviteCode: input1Controller.text,
                    nhsId: input2Controller.text,
                    password: input3Controller.text);
                loading.value = false;
              } else {
                showErrorSnackbar(
                    'The password needs to contain at least 1 uppercase character,1 lowercase character and 1 number');
              }
            } else {
              showErrorSnackbar('The passwords need to match');
            }
          }
        }
      }
    }
  }

  togglePwdHidden() {
    pwdHidden(!pwdHidden.value);
  }

  toggleInvitePwdHidden() {
    invitePwdHidden(!invitePwdHidden.value);
  }

  toggleInvitePwdConfirmHidden() {
    invitePwdConfirmHidden(!invitePwdConfirmHidden.value);
  }

  bool validatePassword(String s) {
    return (s.length >= 6 &&
        s.containsLowercase &&
        s.containsUppercase &&
        s.containsNumber);
  }
}

extension StringValidators on String {
  bool get containsUppercase => contains(RegExp(r'[A-Z]'));

  bool get containsLowercase => contains(RegExp(r'[a-z]'));

  bool get containsNumber => contains(RegExp(r'[0-9]'));
}
