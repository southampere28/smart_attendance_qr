import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadCard extends StatelessWidget {
  const ShimmerLoadCard({
    super.key,
    this.shimmerItemCount = 3,
  });

  final int shimmerItemCount;

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
            height: 100,
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
