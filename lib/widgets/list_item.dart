import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/ui/theme/text_styles.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ListItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5FA), // 리스트 아이템 배경색
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest),
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.neutralDarkLight,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}
