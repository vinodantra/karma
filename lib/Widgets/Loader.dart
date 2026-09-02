// ignore_for_file: file_names

import '../Constants/Library.dart';
class Loader {
  Loader() : super(){
    loader();
  }

  void loader(){

    showDialog(
        context: DataInfo.navKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              width: 100,
              height: 90,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  Card(
                    elevation: 10.0,
                    child:  CircularProgressIndicator(
                      color: appColor.value,
                    ).p20(),
                  ),
                ],
              ),
            ),
          );
        });
    // Get.dialog(
    //     Center(
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children:  [
    //       Card(
    //         elevation: 10.0,
    //         child: const CircularProgressIndicator(
    //           color: appColor,
    //         ).p20(),
    //       ),
    //     ],
    //   ),
    // ));
  }

  hide(){
    Navigator.pop(DataInfo.navKey.currentContext!);
    Navigator.pop(DataInfo.navKey.currentContext!);


  }
}