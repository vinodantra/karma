

// ignore_for_file: file_names

import '../Constants/Library.dart';


class NotificationListProvider extends ChangeNotifier{
  int badgesCount = 0;
  List<dynamic> notificationList = [];

  getData() async{
    String? data = await SharedPrefHelper.getString(DataInfo.notificationKey);

    if(data != null)
    {

      notificationList =  json.decode(data);




      notifyListeners();


    }
  }
  updateNotificationData({required List<dynamic> list,required int count}){
    notificationList = list;
    badgesCount = count;
    notifyListeners();
  }
}