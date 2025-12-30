import 'package:get_it/get_it.dart';
import '../features/Community/ViewModels/main_view_model.dart';
import '../features/Community/ViewModels/prefrences_view_model.dart';

Future<void> $initGetIt(GetIt g, {String? environment}) async{
  g.registerLazySingleton<PreferencesViewModel>(() => PreferencesViewModel());
  g.registerLazySingleton<MainViewModel>(() => MainViewModel());
}