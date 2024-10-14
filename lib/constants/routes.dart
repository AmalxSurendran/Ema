import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/controllers/pose_detection_controller.dart';
import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/exercise_monitoring_page.dart';
import 'package:ema_v4/exercise_monitoring/pages/task_completion/task_completion_page.dart';
import 'package:ema_v4/pages/faq/faq_page.dart';
import 'package:ema_v4/pages/feedback/feedback_controller.dart';
import 'package:ema_v4/pages/feedback/feedback_page.dart';
import 'package:ema_v4/pages/forgot_password/forgot_password_controller.dart';
import 'package:ema_v4/pages/forgot_password/forgot_password_page.dart';
import 'package:ema_v4/pages/permissions/permissions_page.dart';
import 'package:get/get.dart';
import '../exercise_monitoring/pages/exercise_monitoring/controllers/exercise_monitoring_controller.dart';
import '../exercise_monitoring/pages/task_completion/task_completion_controller.dart';
import '../exercise_monitoring/pages/tilt_calibration/tilt_calib_controller.dart';
import '../exercise_monitoring/pages/tilt_calibration/tilt_calib_page.dart';
import '../pages/about/about_page.dart';
import '../pages/app_settings/app_settings_page.dart';
import '../pages/app_settings/app_settings_page_controller.dart';
import '../pages/faq/faq_controller.dart';
import '../pages/home/home_controller.dart';
import '../pages/home/home_page.dart';
import '../pages/login/controller/login_controller.dart';
import '../pages/login/login_screen.dart';
import '../pages/permissions/controller/permissions_controller.dart';
import '../pages/report_detail/report_detail_page.dart';
import '../pages/reports/reports_page.dart';
import '../pages/reports/reports_page_controller.dart';
import '../pages/splash/splash_screen.dart';
import '../pages/task_detail/task_detail_page.dart';
import '../pages/task_detail/task_detail_page_controller.dart';
import '../pages/task_list/task_list_page.dart';
import '../pages/task_list/task_list_page_controller.dart';
import '../pages/update_profile/update_profile_page.dart';
import '../pages/update_profile/update_profile_page_controller.dart';

List<GetPage> routes = [
  GetPage(name: SplashPage.routeName, page: () => const SplashPage()),
  GetPage(
    name: LoginPage.routeName,
    page: () => const LoginPage(),
    binding: BindingsBuilder(() {
      Get.put(LoginController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: ForgotPasswordPage.routeName,
    page: () => const ForgotPasswordPage(),
    binding: BindingsBuilder(() {
      Get.put(ForgotPasswordController());
    }),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: PermissionsPage.routeName,
    page: () => const PermissionsPage(),
    binding: BindingsBuilder(() {
      Get.put(PermissionsPageController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: HomePage.routeName,
    page: () => const HomePage(),
    binding: BindingsBuilder(() {
      Get.put(HomeController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: AboutPage.routeName,
    page: () => const AboutPage(),
    // binding: BindingsBuilder(() {
    //   Get.put(HomeController());
    // }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: FAQPage.routeName,
    page: () => const FAQPage(),
    binding: BindingsBuilder(() {
      Get.put(FAQController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: FeedbackPage.routeName,
    page: () => const FeedbackPage(),
    binding: BindingsBuilder(() {
      Get.put(FeedbackPageController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: TaskListPage.routeName,
    page: () => const TaskListPage(),
    binding: BindingsBuilder(() {
      Get.put(TaskListPageController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: ReportsPage.routeName,
    page: () => const ReportsPage(),
    binding: BindingsBuilder(() {
      Get.put(ReportsPageController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: ReportDetailPage.routeName,
    page: () => const ReportDetailPage(),
    // binding: BindingsBuilder(() {
    //   Get.put(ReportsPageController());
    // }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: TaskDetailPage.routeName,
    page: () => const TaskDetailPage(),
    binding: BindingsBuilder(() {
      Get.put(TaskDetailPageController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: UpdateProfilePage.routeName,
    page: () => const UpdateProfilePage(),
    binding: BindingsBuilder(() {
      Get.put(UpdateProfilePageController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: AppSettingsPage.routeName,
    page: () => const AppSettingsPage(),
    binding: BindingsBuilder(() {
      Get.put(AppSettingsPageController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: TiltCalibPage.routeName,
    page: () => const TiltCalibPage(),
    binding: BindingsBuilder(() {
      Get.put(TiltCalibController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: ExerciseMonitoring.routeName,
    page: () => const ExerciseMonitoring(),
    binding: BindingsBuilder(() {
      Get.put(PoseDetectorController());
      Get.put(EMController());
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: TaskCompletionPage.routeName,
    page: () => const TaskCompletionPage(),
    binding: BindingsBuilder(() {
      Get.put(TaskCompletionController());
    }),
    transition: Transition.cupertino,
  ),
];