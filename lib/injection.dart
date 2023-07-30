import 'package:adviser/0_data/datasources/advice_remote_datasource.dart';
import 'package:adviser/0_data/repositories/advice_repo_impl.dart';
import 'package:adviser/1_domain/repositories/advice_repo.dart';
import 'package:adviser/1_domain/usecases/advice_usecases.dart';
import 'package:adviser/2_application/pages/advice/cubit/adviser_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {

  // ! application layer
    // Factory = every time a new/fresh instance of that class
    sl.registerFactory(() => AdviserCubit(adviceUseCases: sl()));

  // ! domain layer
    sl.registerFactory(() => AdviceUseCases(adviceRepo: sl()));
  
  // ! data layer
    sl.registerFactory<AdviceRepo>(() => AdviceRepoImpl(adviceRemoteDatasource: sl()));
    sl.registerFactory<AdviceRemoteDatasource>(() => AdviceRemoteDatasourceImpl(client: sl()));

  // ! externs
    sl.registerFactory(() => http.Client());
}