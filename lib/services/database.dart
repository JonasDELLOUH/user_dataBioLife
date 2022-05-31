import 'dart:math';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/member.dart';
import '../models/using_data.dart';

class DatabaseService {
  Future<MemberModel> addMember(String memberKey) async {
    MemberModel _memberModel = MemberModel(memberKey);
    await FirebaseFirestore.instance
        .collection("Member")
        .doc(memberKey)
        .set({"memberUid": memberKey}).catchError((e) {
      print("Member non ajouté : ");
      print(e);
    });
    return _memberModel;
  }

  Future<void> addUsing(String memberKey, UsingData usingData) async {
    try{
      await FirebaseFirestore.instance
          .collection("Member")
          .doc(memberKey)
          .collection("UsingData")
          .doc()
          .set({"openedTime" : usingData.openedTime, "closedTime" : usingData.closedTime, "deviceInfo" : usingData.deviceInfo});
    } catch(e){
      if (kDebugMode) {
        print("Using data not add : ${e.toString()}");
      }

    }
  }
}
