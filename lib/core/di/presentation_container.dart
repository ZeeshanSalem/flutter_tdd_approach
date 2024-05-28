import 'package:games/ui/game_deals/presentaion/cubit/game_deal_cubit.dart';

import 'injection_container_common.dart';

Future<void> initPresentationDI() async {
  serviceLocator.registerFactory<GameDealCubit>(
    () => GameDealCubit(
        dealRepository: serviceLocator(),
        ),
  );

}
