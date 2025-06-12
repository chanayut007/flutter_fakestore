import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class ServiceLocator {
  static void setup() {
    GetIt.I.registerLazySingleton<String>(() => 'https://fakestoreapi.com');
    GetIt.I.registerLazySingleton<Dio>(
        () => Dio(BaseOptions(baseUrl: GetIt.I.get<String>())));
  }
}
