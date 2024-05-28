import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games/core/common_widgets/common_widget.dart';
import 'package:games/core/common_widgets/no_data_found.dart';
import 'package:games/core/utils/app_colors.dart';
import 'package:games/ui/game_deals/presentaion/cubit/game_deal_cubit.dart';
import 'package:games/ui/game_deals/presentaion/cubit/game_deal_state.dart';
import 'package:games/ui/game_deals/presentaion/ui/widgets/deal_tile.dart';

class DealMainView extends StatelessWidget {
  const DealMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('deal_main_view'),
      appBar: AppBar(
        title: const Text('Special Offers'),
      ),
      body: BlocBuilder<GameDealCubit, GameDealState>(
        builder: (context, state) {
          if (state.status == GameDealStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: CustomColors.primary,
              ),
            );
          }
          if (state.status == GameDealStatus.failure) {
            return Center(
              child: FailureWidget(
                onPressed: () {
                  context.read<GameDealCubit>().getDeals();
                },
              ),
            );
          }

          return (state.deals ?? []).isEmpty
              ? NoDataFound(onFresh: () {
                  context.read<GameDealCubit>().getDeals();
                })
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 4,
                  ),
                  itemCount: state.deals?.length ?? 0,
                  itemBuilder: (context, index) => DealTile(
                    deal: state.deals?[index],
                  ),
                );
        },
      ),
    );
  }
}
