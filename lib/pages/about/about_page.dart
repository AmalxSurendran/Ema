import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);
  static const String routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About EMA'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('about.aboutApp.header'.c, style: Get.theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),),
              space1,
              Text('about.aboutApp.content'.c),
              space4,
              Text('about.em.header'.c, style: Get.theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),),
              space1,
              AspectRatio(aspectRatio: 1, child: SvgPicture.asset('assets/images/permissions/Camera.svg'),),
              space1,
              Text('about.em.content'.c),
              space4,
              Text('about.extra1.header'.c, style: Get.theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),),
              space1,
              Text('about.extra1.content'.c),
              space4,
            ],
          ),
        ),
      ),
    );
  }
}
