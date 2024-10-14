import 'package:ema_v4/models/api/request/forgotPassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../services/apiService.dart';

class ForgotPasswordController extends GetxController{
  final TextEditingController input1Controller=TextEditingController();
  final TextEditingController input2Controller=TextEditingController();
  final RxBool loading =RxBool(false);

  Future<void> requestPasswordReset() async {
    if(input1Controller.text.isNotEmpty){
      if(input2Controller.text.isNotEmpty){
        loading.value=true;
        await ApiService().passwordReset(PasswordResetRequest(nhsId: input1Controller.text, email: input2Controller.text));
        loading.value=false;
      }
    }
  }
}