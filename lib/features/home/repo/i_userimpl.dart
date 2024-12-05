import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:totalxtest/features/home/data/i_userfacade.dart';
import 'package:totalxtest/features/home/data/model/user_model.dart';
import 'package:totalxtest/general/failures/failures.dart';
import 'package:totalxtest/general/utils/firebase_collections.dart';

@LazySingleton(as: IUserfacade)
class IUserimpl implements IUserfacade {
  final FirebaseFirestore firestore;
  IUserimpl(this.firestore);

  @override
  Future<Either<MainFailure, UserModel>> uploadUser(
      {required UserModel userModel}) async {
    try {
      final userRef = firestore.collection(FirebaseCollections.users);
      final id = userRef.doc().id;

      final user = userModel.copyWith(id: id);

      await userRef.doc(id).set(user.toMap());

      return right(user);
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }

  DocumentSnapshot? lastDocument;
  bool noMoreData = false;

  @override
  Future<Either<MainFailure, List<UserModel>>> fetchUser(
      {int? filterOlder, String? search}) async {
    if (noMoreData) return right([]);
    try {
      Query query = firestore
          .collection(FirebaseCollections.users)
          .orderBy("age", descending: true);

      if (filterOlder != null) {
        // log("filter$filterOlder");
        if (filterOlder == 1) {
          query = query.where('age', isLessThanOrEqualTo: 40);
          // log('l;lllll');
        } else if (filterOlder == 2) {
          // log("message");
          query = query.where('age', isGreaterThan: 40);
        }
      }

      if (search != null) {
        query = query.where('searchKeywords',
            arrayContains: search.replaceAll(" ", "").toLowerCase());
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final querySnapshot = await query.limit(15).get();

      if (querySnapshot.docs.length < 15) {
        noMoreData = true;
      } else {
        lastDocument = querySnapshot.docs.last;
      }

      final newlist = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      log("sswsw${newlist.length}");

      return right(newlist);
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }

  @override
  void clearData() {
    lastDocument = null;
    noMoreData = false;
  }
}
