import 'package:ema_v4/pages/home/widgets/exerciseCard.dart';
import 'package:ema_v4/pages/home/widgets/main_drawer.dart';
import 'package:ema_v4/pages/home/widgets/reportsCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/ui/spacing.dart';
import '../reports/reports_page.dart';
import '../task_list/task_list_page.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      endDrawer: HomeDrawer(),
      body: Padding(
        padding: pagePadding,
        child: controller.appController.patient.currentCourse != null
            ? _courseAvailable(context)
            : _noCourseAvailable(context),
      ),
    );
  }

  _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome',
                style: Get.theme.textTheme.bodyMedium,
              ),
              Text(
                "${controller.appController.patient.name.given} ${controller.appController.patient.name.family ?? ''}",
                style: Get.theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.scaffoldKey.currentState!.openEndDrawer();
          },
          child: SvgPicture.asset(
            'assets/images/ema_menu.svg',
            color: Get.theme.colorScheme.primary,
            height: 28.0,
            width: 28.0,
          ),
        ),
      ],
    );
  }

  _noCourseAvailable(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        space4,
        _header(context),
        space4,
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/images/no_course.svg', width: 200.0,),
                space1,
                const Text('There is no course prescribed to you at the moment'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _courseAvailable(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          space4,
          _header(context),
          space4,
          HomeExerciseCard(
            homeController: controller,
          ),
          space4,
          HomeReportsCard(),
          space4,
        ],
      ),
    );
  }
}
