import 'package:games/core/cubit/base_cubit.dart';
import 'package:games/core/error/models/error_response_model.dart';

import '../../domain/repository/deal_repository.dart';
import 'game_deal_state.dart';

class GameDealCubit extends BaseCubit<GameDealState> {
  GameDealCubit({required this.dealRepository})
      : super(const GameDealState(
          status: GameDealStatus.initial,
        )) {
    getDeals();
  }

  final DealRepository dealRepository;

  getDeals() async {
    try {

      emit(
        const GameDealState(
          status: GameDealStatus.loading,
        ),
      );
      final response = await dealRepository.getAllDeals();

      response.fold(
        (l) {
          emit(
            GameDealState(
              status: GameDealStatus.failure,
              errorModel: handleException(l),
            ),
          );
        },
        (r) {
          emit(
            GameDealState(
              status: GameDealStatus.success,
              deals: r,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        GameDealState(
          status: GameDealStatus.failure,
          errorModel: ErrorModel(message: '$e'),
        ),
      );
    }
  }
}
