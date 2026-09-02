// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api, file_names, must_be_immutable

import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:karma/Constants/Library.dart';


class CustomBottomSheet extends StatefulWidget {
  List<dynamic> list;
  String parameter;
  bool showSearchWidget;
  ValueChanged<Map<String,dynamic>>? data;
  String? title;

  CustomBottomSheet(
      {super.key,
      required this.list,
      required this.parameter,
      this.showSearchWidget = true,this.data,this.title});

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState(
      list: list, parameter: parameter, showSearchWidget: showSearchWidget);
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  List<dynamic> list;
  bool showSearchWidget;
  String parameter;
  _CustomBottomSheetState(
      {required this.list,
      required this.parameter,
      this.showSearchWidget = true});
  List<dynamic> fList = [];
  String search = "";
  TextEditingController searchController = TextEditingController();
  String selectData = "";
  int selectIndex = -1;
  @override
  void initState() {
    fList = list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: list.length >= 3 ? 450 : list.length == 2 ? 300 : 240,

      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36.0), topRight: Radius.circular(36.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0x3f929292),
            blurRadius: 27,
            offset: Offset(0, -4),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 134,
            height: 5,
            decoration: ShapeDecoration(
              color: dividerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ).p16(),
         Align(
          alignment: Alignment.centerLeft,
          child: TextWidget("Select",
            color: blackColor,
            fontSize: 18,

            fontWeight: FontWeight.w500,
          ),
        ).pSymmetric(h: 20.0),
        showSearchWidget ?
        Container(
              width: Get.width * 0.9,
             // height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: surfaceColor,
              ),
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 16,
              //   vertical: 8,
              // ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    search = value;
                    filterData();
                  });
                },
                controller: searchController,

                decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: const TextStyle(
                      color: subtleTextColor,
                      fontSize: 12,
                    ),
                    border: InputBorder.none,
                    constraints: const BoxConstraints(
                      minHeight: 40,
                      maxHeight: 50
                    ),

                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: search.trim().isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              updateData();
                            },
                            icon: const Icon(Icons.close))
                        : const SizedBox()),
              )).pOnly(top: 20.0,bottom: 10.0 ) : const SizedBox(height: 30,),
          fList.isNotEmpty
              ? Expanded(
                child: Scrollbar(
                  thickness: 5.0,
                  trackVisibility: true,

                  thumbVisibility: true,
                  child: ListView.builder(

                    shrinkWrap: true,
                      itemCount: fList.length,

                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if(index != selectIndex){
                                selectIndex = index;
                              }
                              else{
                                selectIndex  = -1;
                              }
                              widget.data!(fList[selectIndex]);
                              selectIndex = -1;

                              // selectData = fList[index][parameter];
                              // widget.data!(fList[index]);
                            });
                            // controller.selectNoc
                            //     .value =
                            // bookingController
                            //     .fNatureOfCall[
                            // index]['NAME'];
                            //
                            // Get.back();
                          },
                          child: Container(
                            width: Get.width,
                            height: 60,
                            decoration: BoxDecoration(
                              border: selectIndex == index ?  GradientBoxBorder(
                                gradient: LinearGradient(
                                    colors:
                                    Provider.of<AppThemeController>(context)
                                        .appGradientColor),
                                width: 1.0,
                              ) : Border.all(width: 0.50, color: dividerColor),
                              // border: Border.all(width: 0.50, color: dividerColor),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3fb0b0b0),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.7,
                                  child: TextWidget(
                                    "${fList[index][parameter]}",
                                    color: darkTextColor,
                                    fontSize: 16,

                                  ),
                                ),
                                index == selectIndex ? CustomWidgets.showAssetImage(path: select) : const SizedBox(),
                                selectData == fList[index][parameter]
                                    ? const Icon(
                                        Icons.check,
                                        color: Color(0xffBDC0CE),
                                      )
                                    : const SizedBox(),
                              ],
                            ).pSymmetric(h: 25.0),
                          ).pSymmetric(h: 20.0,v: 5.0),
                        );
                      }),
                ),
              )
              : SizedBox(
                height: 240,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Center(
                        child: TextWidget(
                          "No data found.",
                          fontSize: 25,
                        ),
                      ),
                  ],
                ),
              ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     Container(
          //       width: 165.50,
          //       height: 48,
          //
          //       decoration: decoration1(context),
          //
          //
          //     child: GradientText(
          //       "Cancel",
          //       gradient: LinearGradient(
          //           colors: Provider.of<AppThemeController>(context).appGradientColor,),
          //
          //       style: const TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w600
          //       ),
          //     ).centered(),).onInkTap(() {
          //       selectIndex = -1;
          //       Get.back();
          //     }),
          //     Container(
          //       width: 165.50,
          //       height: 48,
          //       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          //       decoration: ShapeDecoration(
          //         gradient: LinearGradient(
          //           begin: const Alignment(1.00, 0.00),
          //           end: const Alignment(-1, 0),
          //           colors: Provider.of<AppThemeController>(context).appGradientColor,
          //         ),
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          //       ),
          //       child: TextWidget("Done",color: Colors.white,
          //         fontSize: 16,
          //
          //         fontWeight: FontWeight.w600,).centered()
          //     ).onInkTap(() {
          //       widget.data!(fList[selectIndex]);
          //       selectIndex = -1;
          //     })
          //   ],
          // ).pSymmetric(v: 10.0),
        ],
      ),
    );
  }

  updateData() {
    setState(() {
      searchController.text = "";
      search = "";
      fList = list;
    });
  }

  filterData(){
    setState(() {
      fList = list
          .where((element) =>
          element[parameter]
              .toString()
              .trim()
              .toLowerCase()
              .contains(search.trim().toLowerCase()))
          .toList();
    });
  }
}
