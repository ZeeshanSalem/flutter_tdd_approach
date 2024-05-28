import 'package:flutter/material.dart';
import 'package:games/core/error/models/error_response_model.dart';

import '../utils/app_colors.dart';


class FailureWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final ErrorModel? errorModel;
  final String buttonName;

  const FailureWidget(
      {required this.onPressed,
      this.errorModel,
      this.buttonName = 'Try Again',
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   "Oops",
              //   style: CustomTypography.h1EerieBlack,
              // ),
              Icon(
                Icons.warning,
                color: CustomColors.error,
              ),
            ],
          ),

          Text(
            errorModel?.message ?? "Something went Wrong!",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
                backgroundColor: CustomColors.error,
            ),
            child: Text(
              buttonName,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }


}
