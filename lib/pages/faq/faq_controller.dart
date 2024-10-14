import 'dart:io';
import 'package:ema_v4/controllers/app_controller.dart';
import 'package:ema_v4/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/inMemory/faq_model.dart';
import '../../utils/cf_downloader.dart' as cf_downloader;

class FAQController extends GetxController {
  Rxn<List<FAQ>> faqs = Rxn<List<FAQ>>();
  final AppController appController = Get.find();
  final AuthController authController = Get.find();

  @override
  Future<void> onInit() async {
    final file = File('${(await getTemporaryDirectory()).path}/faq.json');
    try {
      await cf_downloader.downloadFile(
          appController.additionalAssetUrls[2],
          authController.accessToken.value!,
          file);
      faqs(faqFromJson(file.readAsStringSync()));
      file.delete();
    } on Exception catch (e) {
      debugPrint('Error downloading faqs: $e ${appController.additionalAssetUrls[2]}');
      faqs([]);
    }
    super.onInit();
  }
}
