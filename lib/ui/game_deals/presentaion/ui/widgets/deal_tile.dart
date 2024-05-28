import 'package:flutter/material.dart';
import 'package:games/core/utils/assets_path.dart';
import 'package:games/ui/game_deals/data/model/response/deal_response.dart';

class DealTile extends StatelessWidget {
  const DealTile({super.key, this.deal});

  final DealData? deal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FadeInImage(
                placeholder: const AssetImage(ImagePath.placeHolder),
                image: NetworkImage('${deal?.thumb}'),
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    deal?.title ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  RichText(
                    text: TextSpan(
                      text: '\$${deal?.normalPrice ?? '-'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                      children: [
                        TextSpan(
                          text: ' \$${deal?.salePrice ?? '-'} ',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
