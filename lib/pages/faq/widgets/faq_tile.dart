import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/ui/shape.dart';

class FAQTile extends StatelessWidget {
  FAQTile({Key? key, required this.question, required this.answer})
      : super(key: key);
  final RxBool expanded = RxBool(false);
  final String question, answer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Obx(
        () => ExpansionTileCard(
          onExpansionChanged: (state) {
            expanded(state);
          },
          contentPadding: const EdgeInsets.only(right: 8, left: 8),
          baseColor: Get.theme.cardColor,
          expandedColor: Get.theme.colorScheme.primary,
          trailing: Icon(
            expanded.isTrue
                ? Icons.arrow_drop_up_rounded
                : Icons.arrow_drop_down_rounded,
            size: 32,
            color: expanded.isFalse
                ? Get.theme.primaryColor
                : Get.theme.colorScheme.onPrimary,
          ),
          title: Text(question,
              style: Get.textTheme.titleMedium?.copyWith(
                  color: expanded.isFalse
                      ? Get.theme.primaryColor
                      : Get.theme.colorScheme.onPrimary)),
          borderRadius: BorderRadius.all(rad1),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                answer,
                style: Get.textTheme.bodyMedium!.copyWith(height: 2,color: Get.theme.colorScheme.onPrimary,fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
