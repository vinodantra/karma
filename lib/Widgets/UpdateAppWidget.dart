// ignore_for_file: file_names

import '../Constants/Library.dart';
class UpdateAppWidget extends GetView<UpdateAppController> {
  const UpdateAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UpdateAppController());
    return PopScope(
      canPop: DataInfo.updateAvailable.value ? false : true,

      child: Scaffold(
        body: Obx(()=>Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))
          ),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            mainAxisSize: MainAxisSize.min,
            children: [
              DataInfo.updateAvailable.value ==  false ?
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: (){
                    if(controller.isDownload.value == false){
                      Get.back();
                    }

                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black,width: 1.0),
                    ),
                    child: const Icon(Icons.close).p4(),
                  ).p8(),
                ),
              ) : const SizedBox(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tips_and_updates,size: 100,
                        color: Provider.of<AppThemeController>(Get.context!).appColor),
                    20.heightBox,
                    SizedBox(
                      width: Get.width,
                      child: TextWidget(DataInfo.updateAvailable.value ? "Update your app to the latest version" : "No update available",
                        textAlign: TextAlign.center,
                        fontSize: 25,
                        color: titleColor,fontWeight: titleFontWeight,
                        maxLines: 4,),
                    ),
                    20.heightBox,
                    DataInfo.updateAvailable.value ?  TextButton(onPressed: (){
                      Utilities.onClickLink(DataInfo.url.value,
                      mode: LaunchMode.inAppWebView);
                    },
                        child: TextWidget("What's New",
                          textAlign: TextAlign.center,
                          fontSize: 18,
                          textDecoration: TextDecoration.underline,
                          color: Provider.of<AppThemeController>(Get.context!).appColor,fontWeight: titleFontWeight,
                        ),) : const SizedBox(),

                  controller.isDownload.value ?   Column(
                      children: [
                        20.heightBox,
                        controller.isDownload.value == true
                            ? SizedBox(
                          height: 10,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.grey[200],
                            valueColor:  AlwaysStoppedAnimation<Color>(
                                Provider.of<AppThemeController>(Get.context!).appColor),
                            value: controller.progress.value,
                            minHeight: 10,
                          ),
                        )
                            : const SizedBox(),
                        20.heightBox,
                        TextWidget("${controller.percentage.value}%",
                          textAlign: TextAlign.center,
                          color: Colors.black,
                          fontSize: 15,fontWeight: FontWeight.w500,
                        ),

                        10.heightBox,

                      ],
                    ) : const SizedBox(),
                  ],
                ).p16(),
              ),



              DataInfo.updateAvailable.value ?   CustomButton(text:
              controller.isDownload.value ? 'Downloading....':'Update',onPressed: (){
                if(controller.isDownload.value == false){

                  controller.updateApp();
                }
              },).p16():const SizedBox(),
            ],
          ),
        )),
      ),
    );
  }
}
