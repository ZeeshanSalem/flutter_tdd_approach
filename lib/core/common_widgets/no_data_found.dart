import 'package:flutter/material.dart';
import 'package:games/core/utils/assets_path.dart';

import '../utils/app_colors.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound(
      {super.key, required this.onFresh, this.msg = 'No Data Found.'});

  final VoidCallback onFresh;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage(
              ImagePath.noDataFound,
            ),
            height: 200,
            width: 200,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              msg,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          OutlinedButton(
            onPressed: onFresh,
            style: OutlinedButton.styleFrom(
              backgroundColor: CustomColors.primary,
            ),
            child: Text(
              'Refresh',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),

        ],
      ),
    );
  }
}
