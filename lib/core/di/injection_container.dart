import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database/database_helper.dart';
import '../../data/datasources/gym_local_datasource.dart';
import '../../data/datasources/review_local_datasource.dart';
import '../../data/repositories/gym_repository_impl.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/services/openai_service.dart';
import '../../domain/repositories/gym_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/gym_commands.dart';
import '../../domain/usecases/gym_queries.dart';
import '../services/preferences_service.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  sl.registerLazySingleton<PreferencesService>(
    () => PreferencesService(sharedPreferences: sl()),
  );

  sl.registerSingleton<DatabaseHelper>(DatabaseHelper.instance);

  sl.registerLazySingleton<GymLocalDataSource>(
    () => GymLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<ReviewLocalDataSource>(
    () => ReviewLocalDataSource(databaseHelper: sl()),
  );

  sl.registerLazySingleton<GymRepository>(
    () => GymRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());

  sl.registerLazySingleton<OpenAIService>(() => OpenAIService());

  sl.registerLazySingleton(() => GetAllGyms(sl()));
  sl.registerLazySingleton(() => GetGymById(sl()));
  sl.registerLazySingleton(() => SearchGyms(sl()));
  sl.registerLazySingleton(() => FilterGyms(sl()));
  sl.registerLazySingleton(() => InsertGym(sl()));
  sl.registerLazySingleton(() => UpdateGym(sl()));
  sl.registerLazySingleton(() => DeleteGym(sl()));
}
