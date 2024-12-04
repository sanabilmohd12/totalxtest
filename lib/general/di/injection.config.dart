// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/home/data/i_userfacade.dart' as _i907;
import '../../features/home/repo/i_userimpl.dart' as _i715;
import '../../features/productuploading/data/i_product_facade.dart' as _i36;
import '../../features/productuploading/repo/i_product_impl.dart' as _i776;
import 'injectable_module.dart' as _i109;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  await gh.factoryAsync<_i109.FirebaseServices>(
    () => firebaseInjectableModule.firebaseServices,
    preResolve: true,
  );
  gh.lazySingleton<_i974.FirebaseFirestore>(
      () => firebaseInjectableModule.firebaseFirestore);
  gh.lazySingleton<_i59.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth);
  gh.lazySingleton<_i907.IUserfacade>(
      () => _i715.IUserimpl(gh<_i974.FirebaseFirestore>()));
  gh.lazySingleton<_i36.IProductFacade>(
      () => _i776.IProductImpl(gh<_i974.FirebaseFirestore>()));
  return getIt;
}

class _$FirebaseInjectableModule extends _i109.FirebaseInjectableModule {}
