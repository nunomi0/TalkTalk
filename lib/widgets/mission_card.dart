import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/ui/theme/text_styles.dart';
import 'package:talktalk/widgets/button/primary_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MissionCard extends StatelessWidget {
  final String missionTitle;
  final String missionDescription;
  final int currentStep;
  final int totalSteps;
  final int missionId;
  final VoidCallback onComplete;

  const MissionCard({
    Key? key,
    required this.missionTitle,
    required this.missionDescription,
    required this.currentStep,
    required this.totalSteps,
    required this.missionId,
    required this.onComplete,
  }) : super(key: key);

  Future<void> completeMissionStep() async {
    final url = 'https://yourapi.com/missions/$missionId/steps/$currentStep/complete';
    final response = await http.patch(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Mission step completed successfully: ${response.body}');
      onComplete();
    } else {
      print('Failed to complete mission step: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = currentStep / totalSteps;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            color: AppColors.highlightDark,
          ),
          SizedBox(height: 20),
          Text(
            '$missionTitle $currentStep/$totalSteps',
            style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            missionDescription,
            style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDark),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          PrimaryButton(
            text: '완료했어요',
            onPressed: () {
              completeMissionStep();
              Navigator.of(context).pop(); // 팝업 닫기
            },
          ),
        ],
      ),
    );
  }
}
