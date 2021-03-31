import 'package:cz2006/controller/PostController.dart';
import 'package:cz2006/controller/StorageRepo.dart';
import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/controller/auth_servcie.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

// create and manage singleton.
void setup() {
  locator.registerLazySingleton<AuthenticationServices>(
      () => AuthenticationServices());
  locator.registerLazySingleton<StorageService>(() => StorageService());
  locator.registerLazySingleton<UserController>(() => UserController());
  locator.registerLazySingleton<PostController>(() => PostController());
}
