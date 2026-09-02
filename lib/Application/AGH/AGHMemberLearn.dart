// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karma/Controller/aghController.dart';

import 'AGHTheme.dart';
import 'AGHWidgets.dart';

/// Member POV — their "What I Learned" entry.
/// Captain feedback is hidden until this is submitted.
class AGHMemberLearn extends StatelessWidget {
  const AGHMemberLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AGHHeader(title: 'What I Learned'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SessionRecap(),
                  const SizedBox(height: 20),
                  const Text(
                    'What did you learn today?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AGHColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Write in your own words. Your captain will review and respond.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AGHColors.textSoft,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _LearningInput(),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Auto-saving draft…',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AGHColors.textFaint,
                        ),
                      ),
                      Text(
                        '168 / 1000',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AGHColors.textFaint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  AGHGradientButton(
                    label: 'Submit Learning',
                    onPressed: () {
                      Get.find<AGHController>().submitMemberLearning();
                      Get.back();
                    },
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AGHColors.pageBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 14,
                          color: AGHColors.textSoft,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Captain feedback is hidden until you submit. Once locked, this learning becomes part of your AGH record.',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: AGHColors.textSoft,
                              height: 1.5,
                            ),
                          ),
                        ),
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

class _SessionRecap extends StatelessWidget {
  const _SessionRecap();

  @override
  Widget build(BuildContext context) {
    const topics = [
      'Sales Activity',
      'Client Communication',
      'Performance Review',
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AGHColors.gradientSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AGHColors.purple.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              AGHAvatar(name: 'Manish Shah', size: 36),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CAPTAIN',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AGHColors.textSoft,
                        letterSpacing: 0.4,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Manish Shah',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AGHColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              AGHStatusChip(kind: AGHStatus.completed, label: '62 min'),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: topics
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          t,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: AGHColors.purple,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningInput extends StatefulWidget {
  const _LearningInput();

  @override
  State<_LearningInput> createState() => _LearningInputState();
}

class _LearningInputState extends State<_LearningInput>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AGHColors.pink.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AGHColors.pink, width: 1.5),
      ),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            fontSize: 13,
            color: AGHColors.text,
            height: 1.55,
          ),
          children: [
            const TextSpan(text: 'Three takeaways:\n\n'),
            const TextSpan(
              text:
                  '1. Break client meetings into discovery → framing → commitment\n',
            ),
            const TextSpan(
              text: '2. Always send a written recap within 24 hours\n',
            ),
            const TextSpan(
              text: '3. Ask for the next meeting date ',
            ),
            const TextSpan(
              text: 'before',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const TextSpan(text: ' leaving'),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: FadeTransition(
                opacity: _c,
                child: Container(
                  width: 1.5,
                  height: 14,
                  color: AGHColors.pink,
                  margin: const EdgeInsets.only(left: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
