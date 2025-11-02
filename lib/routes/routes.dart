import 'package:get/get.dart';
import 'package:insaftelecom/bindings/basebinding.dart';
import 'package:insaftelecom/bindings/sign_in_binding.dart';
import 'package:insaftelecom/bindings/splash_binding.dart';

import 'package:insaftelecom/screens/base_screen.dart';
import 'package:insaftelecom/screens/sign_in_screen.dart';
import 'package:insaftelecom/splash_screen.dart';

const String splash = '/splash-screen';
const String signinscreen = '/sign-in-screen';
const String basescreen = '/base-screen';

List<GetPage> myroutes = [
  GetPage(name: splash, page: () => SplashScreen(), binding: SplashBinding()),
  GetPage(
    name: signinscreen,
    page: () => SignInScreen(),
    binding: SignInControllerBinding(),
  ),
  GetPage(name: basescreen, page: () => BaseScreen(), binding: Basebinding()),
];
