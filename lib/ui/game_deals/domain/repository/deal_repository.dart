import 'package:dartz/dartz.dart';
import 'package:games/ui/game_deals/data/model/response/deal_response.dart';

abstract class DealRepository {
  Future<Either<Exception, List<DealData>>> getAllDeals();

}
