// ignore_for_file: file_names

import '../Constants/Library.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:  [
        Center(
          child: CircularProgressIndicator(
            color: Provider.of<AppThemeController>(context).appColor,
          ),
        )
      ],
    );
  }
}
