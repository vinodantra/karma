// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';
class ValidationWidget extends StatelessWidget {
  const ValidationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextWidget("No data found.",fontSize: 30,)
      ],
    );
  }
}
