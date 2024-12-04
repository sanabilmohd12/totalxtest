import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:totalxtest/features/productuploading/data/i_product_facade.dart';
import 'package:totalxtest/features/productuploading/data/model/i_product_model.dart';
import 'package:totalxtest/general/failures/failures.dart';
import 'package:totalxtest/general/utils/firebase_collections.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: IProductFacade)
class IProductImpl implements IProductFacade {
  final FirebaseFirestore firestore;
  IProductImpl(this.firestore);

  @override
  Future<Either<MainFailure, ProductModel>> uploadProduct({
    required ProductModel productModel,
    required String userId,
  }) async {
    try {
      log('kjhkj');
      final userRef =
          firestore.collection(FirebaseCollections.users).doc(userId);

      final productId = Uuid().v4();

      // Update the user's document to add the product field
      await userRef.update({
        "product.$productId": productModel.copyWith(id: productId).toMap(),
      });

      return right(productModel.copyWith(id: productId));
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }

  DocumentSnapshot? lastDocument;
  bool noMoreData = false;

  @override
  Future<Either<MainFailure, List<ProductModel>>> fetchProduct(
      {required String userId}) async {
    if (noMoreData) return right([]);

    try {
      final userDocs = await firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .get();

      if (userDocs.exists) {
        log("1 ");
        final userData = userDocs.data();
        log("2");

        final Map<String, dynamic> productsMap =
            Map<String, dynamic>.from(userData?['product'] ?? {});
        log("3");
        final List<ProductModel> productList = [];
        log("4");

        productsMap.forEach((key, value) {
          log("4");
          final product = ProductModel.fromMap(value);
          log("5");

          productList.add(product);
          log("6");
        });
        log("7 ${productList.length}");

        return right(productList);
      } else {
        log("8");

        return right([]);
      }
    } catch (e) {
      return left(MainFailure.serverFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<MainFailure, void>> updateProductStock({
    required String userId,
    required String productId,
    required int
        stockValue, 
  }) async {
    try {
      final userRef =
          firestore.collection(FirebaseCollections.users).doc(userId);

      
      await userRef.update({
        'product.$productId.stock': FieldValue.increment(stockValue),
      });

      return right(null); 
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
