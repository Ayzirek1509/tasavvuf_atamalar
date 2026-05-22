import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final String? emoji;
  final String? imageAsset;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    this.emoji,
    this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardBg(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.stroke(context).withValues(alpha: 0.35),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 64,
                child: Center(
                  child: imageAsset != null
                      ? Image.asset(
                          imageAsset!,
                          height: 64,
                          width: 92,
                          fit: BoxFit.contain,
                        )
                      : Text(
                          emoji ?? '',
                          textScaler: const TextScaler.linear(1.0),
                          style: const TextStyle(fontSize: 40),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                textScaler: const TextScaler.linear(1.0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
