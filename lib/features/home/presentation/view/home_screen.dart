import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:totalxtest/features/productuploading/presentation/view/product_screen.dart';
import 'package:totalxtest/features/productuploading/presentation/view/widgets/product_popup.dart';
import 'package:totalxtest/general/widgets/loader_animation.dart';

import '../provider/main_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> productformkey = GlobalKey<FormState>();
  @override
  void initState() {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        mainProvider.initData(
          scrollController: scrollController,
          // filterOlder: mainProvider.sortedOption
        );
      },
    );
    super.initState();
  }

// void scrollListener() async {
//     if (scrollController.position.pixels ==
//             scrollController.position.maxScrollExtent &&
//         !mainProvider.isFetching) {
//       await mainProvider.fetchUser();
//     }
//   }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Consumer<MainProvider>(builder: (context, pro, child) {
            return TextFormField(
              controller: pro.searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: "Search by name",
                hintStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.black54, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.black54, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255), width: 1),
                ),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                pro.searchOption(
                    scrollController: scrollController,
                    option: pro.sortedOption,
                    search: pro.searchController.text);
              },
            );
          }),
          actions: [
            IconButton(
                onPressed: () {
                  bottomsheet(context, scrollController);
                },
                color: Colors.white,
                icon: const Icon(
                  Icons.sort_rounded,
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: 300,
                    height: 300,
                    padding: const EdgeInsets.all(10),
                    child: Consumer<MainProvider>(
                      builder: (context, pro, child) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              AddUserTextField(
                                labelText: "Name",
                                context: context,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  return null;
                                },
                                controller: pro.nameController,
                              ),
                              const SizedBox(height: 30),
                              AddUserTextField(
                                labelText: "Age",
                                keyboardType: TextInputType.number,
                                context: context,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter age';
                                  }
                                  if (value.length != 2) {
                                    return 'Age must be a 2-digit number';
                                  }
                                  return null;
                                },
                                controller: pro.ageController,
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
                                        if (_formKey.currentState!.validate()) {
                                          final navi = Navigator.of(context);
                                          showProgress(context);
                                          await pro.uploadUser(
                                            onFailure: () {
                                              print("failure");
                                              navi.pop();
                                            },
                                            onSuccess: () {
                                              print("success");
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
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        body: Consumer<MainProvider>(
          builder: (context, prov, child) {
            if (prov.userList.isEmpty) {
              return Center(child: Text("No Data Found"));
            } else {
              return ListView.builder(
                controller: scrollController,
                itemCount: prov.userList.length + 1,
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == prov.userList.length) {
                    return prov.isFetching
                        ? const Column(
                            children: [
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 108.0),
                                child: CircularProgressIndicator(),
                              )),
                            ],
                          )
                        : const SizedBox.shrink();
                  }
                  return ListTile(
                    title: Text(prov.userList[index].name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(prov.userList[index].age.toString()),
                        Text(
                          DateFormat('EEE, dd-MMM-yy')
                              .format(prov.userList[index].createdAt.toDate()),
                        ),
                      ],
                    ),
                    trailing: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                  userId: prov.userList[index].id!,
                                ),
                              ));
                        },
                        child: Text("View Products")),
                    onTap: () {
                      log("message");
                      addProductPopup(context,
                          formKey: productformkey,
                          userId: prov.userList[index].id!,
                          username: prov.userList[index].name);
                    },
                  );
                },
              );
            }
          },
        ));
  }
}

Widget Buttons(BuildContext context,
    {required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.03),
    ),
    onPressed: onPressed,
    child: Text(
      label,
      style: TextStyle(color: textColor),
    ),
  );
}

Widget AddUserTextField({
  required String labelText,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  required BuildContext context,
  List<TextInputFormatter>? inputFormatter,
  String? Function(String?)? validator,
}) {
  final screenWidth = MediaQuery.of(context).size.width;

  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    inputFormatters: inputFormatter,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.grey,
        fontSize: screenWidth * 0.04,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.02,
        horizontal: screenWidth * 0.05,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    ),
    validator: validator,
  );
}

void bottomsheet(BuildContext context, ScrollController scrollController) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      final naviPop = Navigator.of(context);

      return Consumer<MainProvider>(
        builder: (context, prov, child) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Sort By Age',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                RadioListTile<int>(
                  fillColor: WidgetStateProperty.all(Colors.blue),
                  title: const Text("All"),
                  value: 0,
                  groupValue: prov.sortedOption,
                  onChanged: (value) async {
                    await prov
                        .updateSortOption(
                            scrollController: scrollController,
                            option: value ?? 0)
                        .whenComplete(
                      () {
                        naviPop.pop();
                      },
                    );
                    // await prov.fetchUser();
                    log("allll ${prov.userList.length},${prov.sortedOption}");
                  },
                ),
                RadioListTile<int>(
                  fillColor: WidgetStateProperty.all(Colors.blue),
                  title: const Text("Age: Younger"),
                  value: 1,
                  groupValue: prov.sortedOption,
                  onChanged: (value) async {
                    await prov
                        .updateSortOption(
                      scrollController: scrollController,
                      option: value ?? 1,
                    )
                        .whenComplete(
                      () {
                        naviPop.pop();
                      },
                    );
                    // await prov.fetchUser(filterOlder: 1);
                    log("younger ${prov.userList.length},${prov.sortedOption}");
                  },
                ),
                RadioListTile<int>(
                  fillColor: WidgetStateProperty.all(Colors.blue),
                  title: const Text("Age: Older"),
                  value: 2,
                  groupValue: prov.sortedOption,
                  onChanged: (value) async {
                    await prov
                        .updateSortOption(
                            scrollController: scrollController,
                            option: value ?? 2)
                        .whenComplete(
                      () {
                        naviPop.pop();
                      },
                    );
                    // await prov.fetchUser(filterOlder: 2).whenComplete(() {

                    // },);
                    log("older ${prov.userList.length},${prov.sortedOption}");
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      );
    },
  );
}
