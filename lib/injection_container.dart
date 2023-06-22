import 'package:curl_manitoba/data/repositories/curling_io_repository.dart';
import 'package:curl_manitoba/domain/useCases/curling_io_repository_use_cases.dart';
import 'package:curl_manitoba/presentation/bloc/curling_io_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
      () => CurlingIoBloc(getScoresCompetitions: sl(), getGames: sl()));

  sl.registerLazySingleton(() => GetScoresCompetitions(sl()));
  sl.registerLazySingleton(() => GetGames(sl()));

  sl.registerLazySingleton<CurlingIORepository>(() => CurlingIORepositoryImp(
      apiBaseHelper: sl(), curlingIOApi: sl(), networkInfo: sl()));
}
