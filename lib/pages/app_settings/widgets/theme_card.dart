import 'package:ema_v4/constants/colors.dart';
import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/ui/shape.dart';
import '../../../utils/ui/text.dart';
import '../app_settings_page_controller.dart';

class ThemeSettingCard extends GetView<AppSettingsPageController> {
  ThemeSettingCard({Key? key}) : super(key: key);
  final optionSpacing=16.0;
  final optionVerPadding=16.0;
  final optionHorPadding=24.0;
  final optionBorderWidth=2.0;
  final optionTextStyle=Get.theme.textTheme.titleLarge;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: allPad2,
        child: Obx(
              ()=> Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'settings.theme.title'.c,
                style: Get.theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              space2,
               Wrap(
                    alignment: WrapAlignment.center,
                    spacing: optionSpacing,
                    runSpacing: optionSpacing,
                    children: [
                      InkWell(
                        onTap: ()=>controller.onThemeSelect(ThemeMode.light),
                        borderRadius: BorderRadius.all(rad2),
                        child: Container(
                          decoration: BoxDecoration(
                              color: card,
                              borderRadius: BorderRadius.all(rad2),
                              border: Border.all(color: controller.configThemeMode.value ==
                                  ThemeMode.light?themeGreen:Get.theme.primaryColor, width: optionBorderWidth)),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: optionVerPadding, bottom: optionVerPadding, right: optionHorPadding, left: optionHorPadding),
                                child: Text(
                                  'settings.theme.light.name'.c,
                                  style: optionTextStyle?.copyWith(
                                      fontWeight: FontWeight.w600, color: primary),
                                ),
                              ),
                              Visibility(
                                visible: controller.configThemeMode.value ==
                                    ThemeMode.light,
                                child: Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: themeGreen,
                                    size: optionTextStyle!.fontSize,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: ()=>controller.onThemeSelect(ThemeMode.dark),
                        borderRadius: BorderRadius.all(rad2),
                        child: Container(
                          decoration: BoxDecoration(
                              color: cardDark,
                              borderRadius: BorderRadius.all(rad2),
                              border: Border.all(color: controller.configThemeMode.value ==
                                  ThemeMode.dark?themeGreen:Get.theme.primaryColor, width: optionBorderWidth)),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: optionVerPadding, bottom: optionVerPadding, right: optionHorPadding, left: optionHorPadding),
                                child: Text(
                                  'settings.theme.dark.name'.c,
                                  style: optionTextStyle?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: primaryDark),
                                ),
                              ),
                              Visibility(
                                visible: controller.configThemeMode.value ==
                                    ThemeMode.dark,
                                child: Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: themeGreen,
                                    size: optionTextStyle!.fontSize,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: ()=>controller.onThemeSelect(ThemeMode.system),
                        borderRadius: BorderRadius.all(rad2),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [card, cardDark], stops: const [0.5, 0.5]),
                              borderRadius: BorderRadius.all(rad2),
                              border: Border.all(color: controller.configThemeMode.value ==
                              ThemeMode.system?themeGreen:Get.theme.primaryColor, width: optionBorderWidth)),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: optionVerPadding, bottom: optionVerPadding, right: optionHorPadding, left: optionHorPadding),
                                child: GradientText(
                                  'settings.theme.system.name'.c,
                                  style: optionTextStyle
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                  gradient: LinearGradient(
                                      colors: [primary, primaryDark],
                                      stops: const [0.5, 0.5]),
                                ),
                              ),
                              Visibility(
                                visible: controller.configThemeMode.value ==
                                    ThemeMode.system,
                                child: Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: themeGreen,
                                    size: optionTextStyle!.fontSize,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
            ],
          ),
        ),
      ),
    );
  }
}
