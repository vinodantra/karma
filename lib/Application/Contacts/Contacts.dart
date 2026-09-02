// ignore_for_file: file_names, deprecated_member_use

import 'package:karma/Constants/Library.dart';
import 'package:karma/Widgets/AsyncStateView.dart';

class Contacts extends GetView<ContactsController> {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ContactsController());
    return Scaffold(
      appBar: AppBarWidget(
        title: "Contact Details",
      ),
      body: Obx(() => Column(
            children: [
              SearchWidget(
                onChanged: (value) {
                  controller.search.value = value!;
                  controller.searchUser();
                },
                controller: controller.searchController,
                hintText: "Search",
                onClose: () {
                  controller.searchController.clear();
                  controller.search.value = "";
                  controller.searchUser();
                },
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: AsyncStateView(
                    isLoading: controller.isLoading.value,
                    hasError: controller.hasError.value,
                    isEmpty: controller.contactList.isEmpty,
                    onRetry: controller.getData,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.contactList.length,
                      itemBuilder: (context, index) {
                        return tileWidget(controller.contactList[index]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  tileWidget(var data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE5E7EB),
                    border: Border.all(
                        color: appGradientColor.first.withValues(alpha: 0.1),
                        width: 2),
                  ),
                  child: ClipOval(
                    child: Utilities.checkString(data['IMAGE'])
                        ? CustomWidgets.profileImage(
                            url: data['IMAGE'], radius: 24)
                        : const Icon(Icons.person,
                            size: 32, color: Color(0xFFBDBDBD)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        data['NAME'] ?? '-',
                        color: titleColor,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                      ),
                      if ((data['TEAMNAME'] ?? '').toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.5),
                          child: TextWidget(
                            data['TEAMNAME'],
                            color: appGradientColor.first,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            maxLines: 1,
                          ),
                        ),
                      if ((data['DESIGNATION'] ?? '').toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.5),
                          child: TextWidget(
                            data['DESIGNATION'],
                            color: descriptionColor,
                            fontSize: 11.5,
                            maxLines: 2,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    _ContactActionBtn(
                      icon: Icons.call,
                      color: appGradientColor.first,
                      onTap: () => Utilities.onClickMobile(
                          data['MOBILE'].toString().trim()),
                    ),
                    _ContactActionBtn(
                      icon: Icons.message,
                      color: appGradientColor.first,
                      onTap: () => Utilities.onClickMessage(
                          data['MOBILE'].toString().trim()),
                    ),
                    _ContactActionBtn(
                      icon: Icons.email,
                      color: appGradientColor.first,
                      onTap: () => Utilities.onClickEmail(
                          data['USEREMAIL'].toString().trim()),
                    ),
                    Material(
                      color: appGradientColor.first.withValues(alpha: 0.12),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          Utilities.onClickWhatsApp(
                              data['MOBILE'].toString().trim());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SvgPicture.asset(
                            'assets/icons/whatsapp-icon.svg',
                            colorFilter: ColorFilter.mode(
                                appGradientColor.first, BlendMode.srcIn),
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          // Container(
          //   width: double.infinity,
          //   height: 1,
          //   color: const Color(0xFFF5F5F5),
          // ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        "Team Owner",
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB0B0B0),
                      ),
                      TextWidget(
                        data['teamOwner']?.toString() ?? '-',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Opacity(
                    opacity: 0.6,
                    child: Wrap(
                      spacing: 6,
                      children: [
                        _ContactActionBtn(
                          icon: Icons.call,
                          color: appGradientColor.first,
                          onTap: () => Utilities.onClickMobile(
                              data['teamownermobile'].toString().trim()),
                          size: 18,
                        ),
                        _ContactActionBtn(
                          icon: Icons.message,
                          color: appGradientColor.first,
                          onTap: () => Utilities.onClickMessage(
                              data['teamownermobile'].toString().trim()),
                          size: 18,
                        ),
                        _ContactActionBtn(
                          icon: Icons.email,
                          color: appGradientColor.first,
                          onTap: () => Utilities.onClickEmail(
                              data['teamowneremail'].toString().trim()),
                          size: 18,
                        ),
                        Material(
                          color: appGradientColor.first.withValues(alpha: 0.12),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              Utilities.onClickWhatsApp(
                                  data['teamownermobile'].toString().trim());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SvgPicture.asset(
                                'assets/icons/whatsapp-icon.svg',
                                colorFilter: ColorFilter.mode(
                                    appGradientColor.first, BlendMode.srcIn),
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;
  const _ContactActionBtn(
      {required this.icon,
      required this.color,
      required this.onTap,
      this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon, color: color, size: size),
        ),
      ),
    );
  }
}
