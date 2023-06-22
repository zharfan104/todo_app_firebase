// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:todo_app_firebase/core/services/firebase_service.dart' as _i5;
import 'package:todo_app_firebase/core/di/register_module.dart' as _i10;
import 'package:todo_app_firebase/features/login/repository/login_repository.dart'
    as _i6;
import 'package:todo_app_firebase/features/logout/repository/logout_repository.dart'
    as _i7;
import 'package:todo_app_firebase/features/register/repository/register_repository.dart'
    as _i8;
import 'package:todo_app_firebase/features/todo/repository/todo_repository.dart'
    as _i9;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i3.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.factory<_i4.FirebaseFirestore>(() => registerModule.firestore);
    gh.singleton<_i5.FirebaseService>(_i5.FirebaseService(
      firebaseAuth: gh<_i3.FirebaseAuth>(),
      firestore: gh<_i4.FirebaseFirestore>(),
    ));
    gh.singleton<_i6.LoginRepository>(
        _i6.LoginRepository(firebaseAuth: gh<_i3.FirebaseAuth>()));
    gh.singleton<_i7.LogoutRepository>(
        _i7.LogoutRepository(firebaseAuth: gh<_i3.FirebaseAuth>()));
    gh.singleton<_i8.RegisterRepository>(
        _i8.RegisterRepository(firebaseAuth: gh<_i3.FirebaseAuth>()));
    gh.singleton<_i9.TodoRepository>(
        _i9.TodoRepository(firebaseService: gh<_i5.FirebaseService>()));
    return this;
  }
}

class _$RegisterModule extends _i10.RegisterModule {}
