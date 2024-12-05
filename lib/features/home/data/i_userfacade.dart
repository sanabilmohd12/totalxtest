import 'package:dartz/dartz.dart';
import 'package:totalxtest/features/home/data/model/user_model.dart';
import 'package:totalxtest/general/failures/failures.dart';

abstract class IUserfacade {
  Future<Either<MainFailure, UserModel>> uploadUser(
      {required UserModel userModel}) {
    throw UnimplementedError('uploadUser not impl');
  }

  Future<Either<MainFailure, List<UserModel>>> fetchUser(
      {int? filterOlder, String? search}) {
    throw UnimplementedError('uploadUser not impl');
  }

  void clearData();
}
