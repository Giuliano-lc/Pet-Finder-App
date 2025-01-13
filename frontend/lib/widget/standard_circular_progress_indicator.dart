import 'package:flutter/material.dart';

import '../design_configs.dart';

class StandardCircularProgressIndicator extends StatelessWidget {
  const StandardCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          color: DesignConfigs.brownColor,
        ),
      ],
    );
  }

}