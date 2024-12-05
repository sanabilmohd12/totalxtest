import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:totalxtest/features/productuploading/data/i_product_facade.dart';
import 'package:totalxtest/features/productuploading/data/model/i_product_model.dart';

class ProductProvider extends ChangeNotifier {
  final IProductFacade iProductFacade;
  ProductProvider(this.iProductFacade);

  TextEditingController productNameController = TextEditingController();
  TextEditingController productPrizeController = TextEditingController();
  TextEditingController productStockController = TextEditingController();
  TextEditingController updateStockController = TextEditingController();

  bool isFetching = false;
  List<ProductModel> productList = [];

  bool isIncrease = true;

  Future<void> uploadProduct({
    required void Function() onFailure,
    required void Function() onSuccess,
    required String userId,
  }) async {
    log("dddd");
    final result = await iProductFacade.uploadProduct(
      productModel: ProductModel(
        userId: userId,
        product: productNameController.text,
        prize: num.parse(productPrizeController.text),
        stock: int.parse(productStockController.text),
        createdAt: Timestamp.now(),
      ),
      userId: userId,
    );
    result.fold(
      (err) {
        log(err.errorMessage);
        onFailure.call();
      },
      (success) {
        clearproducttextfield();
        log('dfghjk');
        onSuccess.call();
      },
    );
    notifyListeners();
  }

  void clearproducttextfield() {
    productNameController.clear();
    productPrizeController.clear();
    productStockController.clear();
  }

  Future<void> _fetchProducts({required String userId}) async {
    isFetching = true;
    productList.clear();

    notifyListeners();

    final result = await iProductFacade.fetchProduct(userId: userId);

    result.fold(
      (err) {
        log('Error fetching products: ${err.errorMessage}');
      },
      (success) {
        if (success.isNotEmpty) {
          productList.clear();
          productList.addAll(success);
          log('Fetched ${success.length} products');
        } else {
          log('No products found');
        }
      },
    );

    isFetching = false;
    notifyListeners();
  }

  // }
  //   isFetching = true;
  //   notifyListeners();

  void clearProductList() {
    iProductFacade.clearData();
    productList = [];
    notifyListeners();
  }

  Future<void> initData({
    required String userId,
  }) async {
    _fetchProducts(userId: userId);
  }

  void toggleStockUpdate(bool value) {
    isIncrease = value;
    notifyListeners();
  }

  void setStockValue(int stock) {
    updateStockController.text = stock.toString();
  }

// update stock
  Future<void> updateProductStock({
    required String userId,
    required String productId,
    required int stockValue,
  }) async {
    final result = await iProductFacade.updateProductStock(
      userId: userId,
      productId: productId,
      stockValue: stockValue,
    );
    result.fold((l) {
      log(l.errorMessage);
    }, (r) {});
    notifyListeners();
  }
}
