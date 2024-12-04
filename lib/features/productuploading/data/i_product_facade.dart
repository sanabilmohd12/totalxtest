import 'package:dartz/dartz.dart';
import 'package:totalxtest/features/productuploading/data/model/i_product_model.dart';
import 'package:totalxtest/general/failures/failures.dart';

abstract class IProductFacade {
  Future<Either<MainFailure, ProductModel>>uploadProduct({required ProductModel productModel,
      required String userId,
      }){
    throw UnimplementedError('upload product not impl');
  }


  Future<Either<MainFailure,List<ProductModel>>> fetchProduct({required String userId}){

    throw UnimplementedError('fetch product not impl');

  }


  Future<Either<MainFailure, void>> updateProductStock({
    required String userId,
    required String productId,
    required int stockValue,
  }){
    
    throw UnimplementedError('fetch product not impl');
  }
  
   void clearData();


}