// ignore_for_file: file_names

import '../../Constants/Library.dart';
import '../../Controller/profileController.dart';
class EditProfile extends GetView<ProfileController> {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    final formKey = GlobalKey<FormState>();
    return Obx(() => PopScope(
          canPop: !controller.isLoading.value,
          child: Scaffold(
              appBar: AppBarWidget(
                title: "Edit Personal Details",
              ),
              body: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Stack(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  "Full Name:",
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: Get.width / 2,
                                  child: TextFormField(
                                    controller: controller.fullName,
                                    validator: (value) =>
                                        requiredField(value, "Full Name"),
                                  ),
                                )
                              ],
                            ),
                            10.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  "Designation:",
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: Get.width / 2,
                                  child: TextFormField(
                                    controller: controller.designation,
                                    validator: (value) =>
                                        requiredField(value, "Designation"),
                                  ),
                                )
                              ],
                            ),
                            20.heightBox,
                            CustomButton(
                              text: "Update",
                              onPressed: () {
                                if (formKey.currentState?.validate() == true) {
                                  controller.updateData();
                                }
                              },
                            )
                          ],
                        ).p16(),
                      ),
                      controller.isLoading.value
                          ? const LoadingScreen()
                          : const SizedBox(),
                    ],
                  ))),
        ));
  }
}
