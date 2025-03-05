// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:euexia/app/modules/splash/bindings/splash_binding.dart';
import 'package:euexia/app/modules/splash/views/splash_view.dart';
import 'package:euexia/app/modules/add_note/bindings/add_note_binding.dart';
import 'package:euexia/app/modules/add_note/views/add_note_view.dart';
import 'package:euexia/app/modules/edit_note/bindings/edit_note_binding.dart';
import 'package:euexia/app/modules/edit_note/views/edit_note_view.dart';
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
/*import 'package:euexia/app/modules/challenges/bindings/challenges_binding.dart';
import 'package:euexia/app/modules/challenges/views/challenges_view.dart';
import 'package:euexia/app/modules/exercises/bindings/exercises_binding.dart';
import 'package:euexia/app/modules/exercises/views/exercises_view.dart';
import 'package:euexia/app/modules/map/bindings/map_binding.dart';
import 'package:euexia/app/modules/map/views/map_view.dart';
import 'package:euexia/app/modules/tips/bindings/tips_binding.dart';
import 'package:euexia/app/modules/tips/views/tips_view.dart';
import 'package:euexia/app/modules/profile/bindings/profile_binding.dart';
import 'package:euexia/app/modules/profile/views/profile_view.dart';*/

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
      name: _Paths.ADD_NOTE,
      page: () => AddNoteView(),
      binding: AddNoteBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_NOTE,
      page: () => EditNoteView(),
      binding: EditNoteBinding(),
    ),
    /*GetPage(
      name: _Paths.CHALLENGES,
      page: () => ChallengesView(),
      binding: ChallengesBinding(),
    ),
    GetPage(
      name: _Paths.EXERCISES,
      page: () => ExercisesView(),
      binding: ExercisesBinding(),
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
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),*/
  ];
}