import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadCard extends StatelessWidget {
  const ShimmerLoadCard({
    super.key,
    this.shimmerItemCount = 3,
    this.customHeight,
  });

  final int shimmerItemCount;

  final double? customHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        shimmerItemCount,
        (index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: customHeight ?? 100,
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
