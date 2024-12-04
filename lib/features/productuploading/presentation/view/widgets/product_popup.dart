import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:totalxtest/features/home/presentation/view/home_screen.dart';
import 'package:totalxtest/features/productuploading/presentation/provider/product_provider.dart';
import 'package:totalxtest/general/widgets/loader_animation.dart';

void addProductPopup(BuildContext context,
    {formKey,
     required String userId,
      String? username,
      }) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Consumer<ProductProvider>(
          builder: (context,product,child) {
            return SingleChildScrollView(
              child: Container(
                  width: 300,
                  height: 500,
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Center(
                          child: Text(username!),
                        ),
                        Text(
                          "Add Product Details",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        AddUserTextField(
                          labelText: "Name",
                          context: context,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Product';
                            }
                            return null;
                          },
                          controller: product.productNameController,
                        ),
                        const SizedBox(height: 30),
                        AddUserTextField(
                          labelText: "Prize",
                          keyboardType: TextInputType.number,
                          context: context,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Prize';
                            }
              
                            return null;
                          },
                          controller: product.productPrizeController,
                        ),
                                              const SizedBox(height: 30),
              
                        AddUserTextField(
                          labelText: "Stock",
                          keyboardType: TextInputType.number,
                          context: context,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter how much Stock is there';
                            }
              
                            return null;
                          },
                          controller: product.productStockController,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: Buttons(
                                context,
                                label: "Cancel",
                                color: Colors.grey[300]!,
                                textColor: Colors.grey,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Buttons(
                                context,
                                label: "Save",
                                color: Colors.blue,
                                textColor: Colors.white,
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    final navi = Navigator.of(context);
                                    log("ggg");
                                    showProgress(context);
                                   await product.uploadProduct(userId: userId,
                                    onSuccess: () {
                                      log("successss");
                                      navi.pop();
              
                                    },
                                    onFailure: () {
                                      log("failedddd");
                                                                            navi.pop();

                                    },
                                    );
                                    navi.pop();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            );
          }
        ),
        
      );
    },
  );
}
