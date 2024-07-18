import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/ui/theme/text_styles.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const CustomCard({
    Key? key,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: AppColors.highlightLightest,
      elevation: 0,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.neutralDarkDarkest.withOpacity(0.5),
                    AppColors.neutralDarkDarkest.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                title,
                style: AppTextStyles.headingH4.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 6.0,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
