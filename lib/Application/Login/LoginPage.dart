// ignore_for_file: file_names

import '../../Constants/Library.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      body: Obx(() => Stack(
            children: [
              ScaleTransition(
                alignment: Alignment.center,
                scale: controller.offsetAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 2),
                      tween: Tween<double>(begin: 40, end: 24),
                      builder: (_, size, __) => AlignTransition(
                        alignment: controller.alignTransaction,
                        child: TextWidget(
                          "Welcome to Karma",
                          color: darkTextColor,
                          fontSize: size,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    36.heightBox,
                    CustomTextField(
                      controller: controller.userNameController,
                      label: "Enter your username",
                      keyboardType: TextInputType.emailAddress,
                      errorText: controller.userNameErrorText.value,
                      textInputAction: TextInputAction.next,
                    ),
                    10.heightBox,
                    CustomTextField(
                      controller: controller.passwordController,
                      label: "Enter your password",
                      obscureText: controller.isShowPassword.value,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        onPressed: () => controller.isShowPassword.value =
                            !controller.isShowPassword.value,
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: controller.isShowPassword.value
                              ? Colors.grey
                              : primaryColor,
                        ),
                      ),
                      errorText: controller.passwordErrorText.value,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => controller.checkData(),
                    ),
                    10.heightBox,
                    InkWell(
                      onTap: () => controller.isRemember.value =
                          !controller.isRemember.value,
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              child: Checkbox(
                                onChanged: (val) =>
                                    controller.isRemember.value = val!,
                                value: controller.isRemember.value,
                              ),
                            ),
                            10.widthBox,
                            TextWidget("Remember Me"),
                          ],
                        ),
                      ),
                    ),
                    70.heightBox,
                    CustomButton(
                      onPressed: controller.checkData,
                      text: "Log In",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    40.heightBox,
                    TextWidget(
                      "Version - V${DataInfo.appVersion.value}",
                      color: appColor.value,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ).pSymmetric(h: 25.0),
              ),
              controller.isLoading.value
                  ? const LoadingScreen()
                  : const SizedBox(),
            ],
          )),
    );
  }
}
   