import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:totalxtest/features/home/data/i_userfacade.dart';
import 'package:totalxtest/general/services/keyword_generator.dart';

import '../../data/model/user_model.dart';

class MainProvider extends ChangeNotifier {
  final IUserfacade iUserfacade;
  MainProvider(this.iUserfacade);

  List<UserModel> userList = [];

  int sortedOption = 0;

  
  bool isFetching = false;


  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  

  // Future<void> uploadUser(
  //   BuildContext context, {
  //   required void Function(String) error,
  //   required void Function() success,
  // }) async {
  //   try {
  //     String id = db.collection("users").doc().id;
  //     final userModel = UserModel(
  //       id: id,
  //       name: nameController.text,
  //       age: int.parse(ageController.text),
  //       createdAt: Timestamp.now(),
  //     );

  //     await db
  //         .collection(FirebaseCollections.users)
  //         .doc(id)
  //         .set(userModel.toMap());
  //     adduserLocally(userModel);
  //     success();
  //     cleartextfield();
  //     notifyListeners();
  //   } on Exception catch (err) {
  //     error(err.toString());
  //   }
  // }

  Future<void> uploadUser({
    required void Function() onFailure,
    required void Function() onSuccess,
  }) async {
    final result = await iUserfacade.uploadUser(
        userModel: UserModel(
      name: nameController.text,
      age: int.parse(ageController.text),
      createdAt: Timestamp.now(),
      searchKeywords: generateKeywords(nameController.text),
    ));
    result.fold(
      (err) {
        log(err.errorMessage);
        onFailure.call();




      },
      (success) {
        cleartextfield();
        log('dfghjk');
        adduserLocally(success);
        onSuccess.call();
      },
    );
    notifyListeners();
  }

  void adduserLocally(UserModel user) {
    userList.insert(0, user);
    notifyListeners();
  }

  void cleartextfield() {
    nameController.clear();
    ageController.clear();
  }

  // Future<void> fetchUser() async {
  //   final value = await db
  //       .collection(FirebaseCollections.users)
  //       // .where('age',isGreaterThanOrEqualTo: 33, )
  //       .orderBy('createdAt', descending: true)
  //       .get();
  //   if (value.docs.isNotEmpty) {
  //     userList.clear();
  //     for (var element in value.docs) {
  //       userList.add(UserModel.fromMap(element.data()));
  //     }
  //   }
  //   notifyListeners();
  // }

  Future<void> _fetchUser({int? filterOlder, String? search}) async {
    isFetching = true;
    notifyListeners();
    final result =
        await iUserfacade.fetchUser(filterOlder: filterOlder, search: search);
        result.fold((err) {
          log(err.errorMessage);
        }, (success) {
          userList.addAll(success);
        },);
        isFetching=false;
        notifyListeners();
  }

  void clearuserList() {
   iUserfacade.clearData();
    userList = [];
    notifyListeners();
  }

  Future<void> updateSortOption(
      {required ScrollController scrollController,
      required int option,
      String? search}) async {
    sortedOption = option;
    clearuserList();
    initData(
      scrollController: scrollController,
    );
    notifyListeners();
  }

  Future<void> searchOption(
      {required ScrollController scrollController,
      int? option,
      String? search}) async {
    clearuserList();
    if (search!.isNotEmpty) {
      initData(
        scrollController: scrollController,
      );

      log("seerched${userList.length}");
    } else {
      initData(
        scrollController: scrollController,
      );
    }
    notifyListeners();
  }

  // void sortUsersByAge() {
  //   sortedList = List.from(userList);

  //   switch (sortedOption) {
  //     case 1:
  //       sortedList = sortedList.where((user) => user.age < 40).toList();
  //       break;
  //     case 2:
  //       sortedList = sortedList.where((user) => user.age >= 40).toList();
  //       break;
  //     default:
  //       break;
  //   }
  //   notifyListeners();
  // }

// MainProvider() {
//     scrollController.addListener(scrollListener);
//   }

  // Future<void> scrollListener() async {
  //   if (scrollController.position.pixels ==
  //           scrollController.position.maxScrollExtent &&
  //       !isFetching) {
  //     await fetchUser();
  //   }
  // }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }

  Future<void> initData({
    required ScrollController scrollController,
  }) async {
    clearuserList();
    if (searchController.text != "") {
      _fetchUser(filterOlder: sortedOption, search: searchController.text);
    } else {
      _fetchUser(
        filterOlder: sortedOption,
      );
    }
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !isFetching) {
          if (searchController.text != "") {
            _fetchUser(
                filterOlder: sortedOption, search: searchController.text);
          } else {
            _fetchUser(
              filterOlder: sortedOption,
            );
          }
          // log("scroll$sortedOption");
        }
      },
    );
  }

// Future<List<UserModel>> searchUsers(String keyword) async {
//   final querySnapshot = await FirebaseFirestore.instance
//       .collection("users")
//       .where('searchKeywords', arrayContains: keyword.toLowerCase())
//       .get();

//   return querySnapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
// }


 




}
