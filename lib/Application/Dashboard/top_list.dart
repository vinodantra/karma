// ignore_for_file: deprecated_member_use

import 'package:karma/Application/Dashboard/model/company_model.dart';
import 'package:karma/Constants/Library.dart';
import 'package:karma/Controller/top_list_controller.dart';

class TopList extends StatefulWidget {
  const TopList({super.key});

  @override
  State<TopList> createState() => _TopListState();
}

class _TopListState extends State<TopList> {
  @override
  void initState() {
    Get.put(TopListController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopListController>(
        builder: (controller) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBarWidget(title: controller.type.value),
              body: Column(
                children: [
                  10.heightBox,
                  _searchBar(controller),
                  _filterChips(controller),
                  const SizedBox(height: 10),
                  _companyList(controller),
                ],
              ),
            ));
  }

  Widget _searchBar(TopListController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Obx(() => TextField(
            onChanged: (value) => controller.searchText.value = value,
            decoration: InputDecoration(
              hintText: 'Search company',
              prefixIcon: const Icon(Icons.search),
              constraints: const BoxConstraints(
                maxHeight: 40,
              ),
              suffixIcon: controller.searchText.value.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: controller.clearSearch,
                    ),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          )),
    );
  }

  Widget _filterChips(TopListController controller) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: controller.filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = controller.filters[index];
          final isSelected = controller.selectedFilter.value == filter;
          return ChoiceChip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            label: Text(filter,
                style: TextStyle(
                  color: isSelected ? appGradientColor.first : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                )),
            selected: isSelected,
            selectedColor: appGradientColor.first.withOpacity(0.12),
            onSelected: (_) {
              controller.selectedFilter.value = filter;
              // controller.filterCompanies();
              controller.update();
            },
          );
        },
      ),
    );
  }

  Color checkColor(TopListController controller, Map<String, dynamic> company) {
    if (controller.type.value == "Top 30") {
      if ((double.tryParse((company['NETVALUE'] ?? '').toString()) ?? 0) >= 100000) {
        return Colors.green;
      } else if ((double.tryParse((company['NETVALUE'] ?? '').toString()) ?? 0) >=
              60000 &&
          (double.tryParse((company['NETVALUE'] ?? '').toString()) ?? 0) < 100000) {
        return Colors.grey;
      } else {
        return Colors.red;
      }
    } else if (controller.type.value == "Next 30") {
      if ((double.tryParse((company['NETVALUE'] ?? '').toString()) ?? 0) >= 60000) {
        return Colors.green;
      } else if ((double.tryParse((company['NETVALUE'] ?? '').toString()) ?? 0) >=
              30000 &&
          (double.tryParse((company['NETVALUE'] ?? '').toString()) ?? 0) < 60000) {
        return Colors.grey;
      } else {
        return Colors.red;
      }
    } else {
      if ((double.tryParse((company['NETVALUE'] ?? '').toString()) ?? 0) >= 30000) {
        return Colors.green;
      } else if ((double.tryParse((company['NETVALUE'] ?? '').toString()) ?? 0) >=
              10000 &&
          (double.tryParse((company['NETVALUE'] ?? '').toString()) ?? 0) < 30000) {
        return Colors.grey;
      } else {
        return Colors.red;
      }
    }
  }

  Widget _companyList(TopListController controller) {
    return Expanded(
      child: controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Obx(() {
              if (controller.filteredList.isEmpty) {
                return const Center(
                  child: Text(
                    'No data found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              return ListView.separated(
                itemCount: controller.filteredList.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final company = controller.filteredList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 6,
                      backgroundColor: checkColor(controller, company),
                    ),
                    title: Text(
                      company['NAME'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      showCompanyBottomSheet(
                        controller: controller,
                        company: company,
                        companyName: company['NAME'],
                        dotColor: appGradientColor.first,
                      );
                    },
                  );
                },
              );
            }),
    );
  }

  void showCompanyBottomSheet({
    required TopListController controller,
    required Map<String, dynamic> company,
    required String companyName,
    required Color dotColor,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(controller, company, companyName, dotColor),
            const SizedBox(height: 12),
            _featureList(company),
            const SizedBox(height: 16),
            _moreDetailsButton(company),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _header(TopListController controller, Map<String, dynamic> company,
      String name, Color dotColor) {
    return Row(
      children: [
        SvgPicture.asset(shieldIcon,
            color: const Color(0xffe0659b), width: 30, height: 30),
        const SizedBox(width: 6),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: checkColor(controller, company),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: Get.back,
        ),
      ],
    );
  }

  Widget _featureList(Map<String, dynamic> company) {
    final features = [
      CompanyFeature('Antra Support Cover (ASC)',
          double.tryParse(company['ASC'].toString())! > 0),
      CompanyFeature('Antra Cloud (AC)',
          double.tryParse(company['Antracloud'].toString())! > 0),
      CompanyFeature('TSS', double.tryParse(company['TSS'].toString())! > 0),
      CompanyFeature(
          'Antra CX (ACX)', double.tryParse(company['CX'].toString())! > 0),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: features.map((f) {
          return ListTile(
            leading: Icon(
              f.enabled ? Icons.check_circle : Icons.cancel,
              color: f.enabled ? Colors.green : Colors.red,
            ),
            title: Text(f.name),
          );
        }).toList(),
      ),
    );
  }

  Widget _moreDetailsButton(company) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: CustomButton(
          onPressed: () {
            Get.to(() => const DataPointInfo(), arguments: {
              "DPID": company['DPID'].toString(),
              "DPNAME": company['NAME'].toString(),
            });
          },
          text: "More details"),
    );
  }
}
