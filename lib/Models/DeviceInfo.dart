// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

class DeviceInfo extends GetxController{
  String? deviceName;
  String? device;
  String? deviceId;
  String? deviceToken;
  String? platform;

  DeviceInfo({this.deviceName,this.device,this.deviceId,this.deviceToken,this.platform});

  DeviceInfo.fromMap(Map<String,dynamic> map){
    deviceName = map['deviceName'];
    device = map['device'];
    deviceId = map['deviceId'];
    deviceToken = map['deviceToken'];
    platform = map['platform'];
  }

  Map<String,dynamic> toMap(){
    return {
      "deviceName":deviceName,
      "device":device,
      "deviceId":deviceId,
      "deviceToken":deviceToken,
      "platform":platform
    };
  }
}


