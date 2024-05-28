import 'package:equatable/equatable.dart';
import 'package:games/core/error/models/error_response_model.dart';
import 'package:games/ui/game_deals/data/model/response/deal_response.dart';

enum GameDealStatus { initial, loading, success, failure }

class GameDealState extends Equatable {
  final GameDealStatus status;
  final ErrorModel? errorModel;
  final List<DealData>? deals;

  const GameDealState({
    this.status = GameDealStatus.initial,
    this.errorModel,
    this.deals,
  });

  factory GameDealState.fromJson(Map<String, dynamic> json) {
    return GameDealState(
      status: GameDealStatus.values[json["status"] ?? 0],
      errorModel: json["errorModel"] != null
          ? ErrorModel.fromJson(json["errorModel"])
          : null,
      deals: json["deals"] != null
          ? List<DealData>.from(
              json["deals"].map((deal) => DealData.fromJson(deal)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "status": status.index,
        "errorModel": errorModel,
        "deals": deals?.map((deal) => deal.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        status,
        errorModel,
        deals,
      ];
}
