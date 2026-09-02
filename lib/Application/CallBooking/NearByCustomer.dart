// ignore_for_file: file_names

import '../../Constants/Library.dart';

class NearByCustomer extends StatelessWidget {
  const NearByCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Nearby Customer",),
      body: Center(
        child: TextWidget("No data found.",fontSize: 20,
        fontWeight: FontWeight.w500,),
      ),
    );
  }
}
