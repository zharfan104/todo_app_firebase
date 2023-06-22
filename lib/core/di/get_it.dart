import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_app_firebase/core/di/get_it.config.dart';

final sl = GetIt.instance;

@InjectableInit()
void configureDependencies() => sl.init();
