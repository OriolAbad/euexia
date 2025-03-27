// ignore_for_file: constant_identifier_names

import 'package:euexia/app/modules/gallery/bindings/gallery_binding.dart';
import 'package:euexia/app/modules/trainings/binding/trainings_binding.dart';
import 'package:euexia/app/modules/trainings/view/trainings_view.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/splash/bindings/splash_binding.dart';
import 'package:euexia/app/modules/splash/views/splash_view.dart';
import 'package:euexia/app/modules/home/bindings/home_binding.dart';
import 'package:euexia/app/modules/home/views/home_view.dart';
import 'package:euexia/app/modules/login/bindings/login_binding.dart';
import 'package:euexia/app/modules/login/views/login_view.dart';
import 'package:euexia/app/modules/settings/views/settings_view.dart';
import 'package:euexia/app/modules/settings/bindings/settings_binding.dart';
import 'package:euexia/app/modules/register/bindings/register_binding.dart';
import 'package:euexia/app/modules/register/views/register_view.dart';
import 'package:euexia/app/modules/forgot_password/views/forgot_password_view.dart';
import 'package:euexia/app/modules/forgot_password/bindings/forgot_password_binding.dart';
import 'package:euexia/app/modules/reset_password/views/reset_password_view.dart';
import 'package:euexia/app/modules/reset_password/bindings/reset_password_binding.dart';
import 'package:euexia/app/modules/gallery/views/gallery_view.dart';
import 'package:euexia/app/modules/gallery/bindings/gallery_binding.dart';
import 'package:euexia/app/modules/map/bindings/map_bindings.dart';
import 'package:euexia/app/modules/map/views/map_view.dart';
import 'package:euexia/app/modules/tips/bindings/tips_binding.dart';
import 'package:euexia/app/modules/tips/views/tips_view.dart';
import 'package:euexia/app/modules/challenges/bindings/challenges_binding.dart';
import 'package:euexia/app/modules/challenges/views/challenges_view.dart';
import 'package:euexia/app/modules/profile/bindings/profile_binding.dart';
import 'package:euexia/app/modules/profile/views/profile_view.dart';
/*
import 'package:euexia/app/modules/exercises/bindings/exercises_binding.dart';
import 'package:euexia/app/modules/exercises/views/exercises_view.dart';*/

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.GALLERY,
      page: () => GalleryView(),
      binding: GalleryBinding(),
    ),
    GetPage(
      name: _Paths.MAP,
      page: () => MapView(),
      binding: MapBinding(),
    ),
    GetPage(
      name: _Paths.TIPS,
      page: () => TipsView(),
      binding: TipsBinding(),
    ),
    GetPage(
      name: _Paths.CHALLENGES,
      page: () => ChallengesView(),
      binding: ChallengesBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.RUTINAS,
      page: () => TrainingsView(),
      binding: TrainingsBinding(),
    ), /*
    GetPage(
      name: _Paths.EXERCISES,
      page: () => ExercisesView(),
      binding: ExercisesBinding(),
    ),
    */
  ];
}
