import 'package:karma/Constants/Library.dart';

class EpicenterScreen extends StatelessWidget {
  const EpicenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Epicenter"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work, size: 100, color: appColor.value),
            const SizedBox(height: 20),
            const Text('Work in Progress', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            const Text('This feature is under development.',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
