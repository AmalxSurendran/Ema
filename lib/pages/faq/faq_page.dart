import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:ema_v4/pages/faq/faq_controller.dart';
import 'package:ema_v4/pages/faq/widgets/faq_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FAQPage extends GetView<FAQController> {
  const FAQPage({Key? key}) : super(key: key);
  static const String routeName = '/faq';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: Padding(
        padding: pagePadding,
        child: Obx(
          () => controller.faqs.value != null
              ? controller.faqs.value!.isNotEmpty
                  ? ListView.builder(
                    itemBuilder: (context, index) {
                      return FAQTile(question: controller.faqs.value![index].question, answer: controller.faqs.value![index].answer);
                    },
                    itemCount: controller.faqs.value?.length,
                  )
                  : Center(
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.onInit();
                          },
                          child: const Text("Retry"),
                        ),
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
