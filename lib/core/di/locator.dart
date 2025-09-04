import 'package:get_it/get_it.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../services/gemini_service.dart';
import '../../services/quiz_repository.dart';


final locator = GetIt.instance;


Future<void> setupLocator() async {
  locator.registerLazySingleton(() => AuthService());
  // locator.registerLazySingleton(() => BookRepository());
  // locator.registerLazySingleton(() => ProgressRepository());
  locator.registerLazySingleton(() => GeminiService());
  // locator.registerLazySingleton(() => QuizRepository(
  //   gemini: locator<GeminiService>(),
  //   progress: locator<ProgressRepository>(),
  // ));
}