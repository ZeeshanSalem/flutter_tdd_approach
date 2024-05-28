import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games/core/di/injection_container_common.dart';
import 'package:games/ui/game_deals/presentaion/cubit/game_deal_cubit.dart';
import 'package:games/ui/game_deals/presentaion/ui/deal_main_view.dart';
import 'package:go_router/go_router.dart';

final GoRouter newRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: '/',
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider<GameDealCubit>(
          create: (context) => serviceLocator<GameDealCubit>(),
          child: const DealMainView(),
        );
      },
    ),
  ],
);
