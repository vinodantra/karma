// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class UserInfo extends GetxController{
  String? userId;
  String? enrollId;
  String? rollId;
  String? imageUrl;
  String? pid;
  String? encKey;


  UserInfo({this.userId,this.enrollId,this.rollId,this.imageUrl,this.pid,this.encKey});

  UserInfo.fromMap(Map<String,dynamic> map){
    userId = map['UID'];
    enrollId = map['ENROLLID'];
    rollId = map['ROLLID'];
    imageUrl = map['IMGURL'];
    pid = map['PID'];
    encKey = map['ENCKEY'];
  }

  Map<String,dynamic> toMap(){
    return {
      "UID":userId,
      "ENROLLID":enrollId,
      "ROLLID":rollId,
      "IMGURL":imageUrl,
      "PID":pid,
      "ENCKEY":encKey,
    };
  }
}