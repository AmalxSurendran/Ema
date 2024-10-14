import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:ema_v4/pages/feedback/feedback_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class FeedbackPage extends GetView<FeedbackPageController> {
  const FeedbackPage({Key? key}) : super(key: key);
  static const String routeName = '/feedback';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: pageHorOnlyPadding,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              space4,
              Text(
                'Topic',
                style: Get.theme.textTheme.bodyMedium
                    ?.copyWith(color: Get.theme.colorScheme.secondary),
              ),
              space1,
              Obx(
                () => DropdownButtonFormField<FeedbackTopic>(
                  dropdownColor: Get.theme.cardColor,
                  value: controller.selectedTopic.value,
                  items: controller.topics
                      .map((e) => DropdownMenuItem<FeedbackTopic>(
                            value: e,
                            child: Text(e.topic),
                          ))
                      .toList(),
                  onChanged: controller.onTopicSelected,
                ),
              ),
              space4,
              Text(
                'Rating',
                style: Get.theme.textTheme.bodyMedium
                    ?.copyWith(color: Get.theme.colorScheme.secondary),
              ),
              space1,
              RatingBar.builder(
                initialRating: 1,
                minRating: 1,
                maxRating: 5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                glowColor: Get.theme.colorScheme.primary,
                unratedColor: Get.theme.colorScheme.secondary,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Get.theme.colorScheme.primary,
                ),
                onRatingUpdate: controller.onRatingChange,
              ),
              space4,
              Obx(() => Text(
                controller.isCommentMandatory.isTrue ? 'Comments (required)' : 'Comments',
                style: Get.theme.textTheme.bodyMedium
                    ?.copyWith(color: Get.theme.colorScheme.secondary),
              ),),
              space1,
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200.0
                ),
                child: TextField(
                  controller: controller.commentInputController,
                  maxLines: null,
                  minLines: 3,
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Type here ...',
                  ),
                ),
              ),
              space4,
              ElevatedButton(onPressed: controller.onSubmitClick, child: const Text('Submit feedback'))
            ],
          ),
        ),
      ),
    );
  }
}
