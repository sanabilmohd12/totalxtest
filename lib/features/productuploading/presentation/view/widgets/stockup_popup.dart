import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:totalxtest/features/home/presentation/view/home_screen.dart';
import 'package:totalxtest/features/productuploading/data/model/i_product_model.dart';
import 'package:totalxtest/features/productuploading/presentation/provider/product_provider.dart';
import 'package:totalxtest/general/widgets/loader_animation.dart';

void stockUpdatePopup(BuildContext context, ProductModel pro,
    {formKey,
    required String userId,
    required String productId,
    String? productName,
    int? productStock}) {
  context.read<ProductProvider>().setStockValue(pro.stock);

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Consumer<ProductProvider>(builder: (context, product, child) {
          return SingleChildScrollView(
            child: Container(
              width: 300,
              height: 500,
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Update Stock",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    SwitchListTile(
                      tileColor: Colors.red,
                      selectedTileColor: Colors.green,
                      selected: product.isIncrease,
                      title: Text(
                        product.isIncrease
                            ? 'Increase Stock'
                            : 'Decrease Stock',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: product.isIncrease,
                      onChanged: (bool value) {
                        product.toggleStockUpdate(value);
                      },
                    ),
                    Text("Product: ${productName!}"),
                    Text("Stock: ${productStock!}"),
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
                        final numValue = int.tryParse(value);
                        if (numValue == null) {
                          return 'Please enter a valid number';
                        }

                        if (product.isIncrease == false &&
                            numValue > productStock) {
                          return "Can't decrease more than $productStock";
                        }

                        return null;
                      },
                      controller: product.updateStockController,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Buttons(context,
                              label: "Cancel",
                              color: Colors.grey[300]!,
                              textColor: Colors.grey, onPressed: () {
                            product.updateStockController.clear();
                            Navigator.pop(context);
                          }),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Buttons(
                            context,
                            label: "Save",
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: () async {
                              log("stockk11");
                              if (formKey.currentState!.validate()) {
                                final navi = Navigator.of(context);
                                log("stockk22");
                                showProgress(context);

                                int stockChange = int.tryParse(
                                        product.updateStockController.text) ?? 0;
                                log("stockk33");
                                if (!product.isIncrease) {
                                  stockChange = -stockChange;
                                }
                                log("stockk44");

                               await product.updateProductStock(
                                  userId: userId,
                                  productId: pro.id!,
                                  stockValue: stockChange,
                                );
                                
                              
                                log("stockk55");

                                navi.pop();
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
        }),
      );
    },
  );
}
