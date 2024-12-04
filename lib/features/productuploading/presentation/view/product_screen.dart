// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalxtest/features/productuploading/presentation/provider/product_provider.dart';
import 'package:totalxtest/features/productuploading/presentation/view/widgets/stockup_popup.dart';

class ProductScreen extends StatefulWidget {
  String userId;
  ProductScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final GlobalKey<FormState> stockformkey = GlobalKey<FormState>();

  @override
  void initState() {
    final productPro = Provider.of<ProductProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await productPro.initData(userId: widget.userId
            // filterOlder: mainProvider.sortedOption
            );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Products"),
      ),
      body: Consumer<ProductProvider>(builder: (context, pro, child) {
        if (pro.productList.isEmpty) {
          return Center(child: Text("No data Found"));
        } else {
          return ListView.builder(
            itemCount: pro.productList.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(pro.productList[index].product),
                subtitle: Text("₹ ${pro.productList[index].prize.toString()}"),
                trailing: TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    onPressed: () {
                      stockUpdatePopup(context, pro.productList[index],
                          productName: pro.productList[index].product,
                          formKey: stockformkey,
                          productStock: pro.productList[index].stock,
                          userId: pro.productList[index].userId,
                          productId: pro.productList[index].id!);
                    },
                    child: Text(
                      pro.productList[index].stock.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
              );
            },
          );
        }
      }),
    );
  }
}
