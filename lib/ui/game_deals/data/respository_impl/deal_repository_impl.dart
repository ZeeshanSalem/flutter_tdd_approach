import 'package:dartz/dartz.dart';
import 'package:games/core/network/network_info.dart';
import 'package:games/ui/game_deals/data/data_source/deal_remote_data_source.dart';

import 'package:games/ui/game_deals/data/model/response/deal_response.dart';

import '../../../../core/error/exception.dart';
import '../../domain/repository/deal_repository.dart';

class DealRepositoryImpl extends DealRepository {
  final NetworkInfo networkInfo;
  final DealRemoteDataSource dealRemoteDataSource;

  DealRepositoryImpl({
    required this.networkInfo,
    required this.dealRemoteDataSource,
  });

  @override
  Future<Either<Exception, List<DealData>>> getAllDeals() async{
    if (networkInfo.isConnected) {
      try {
        final response =
            await dealRemoteDataSource.getDeals();
        // Assuming that the response is a List<dynamic>
        final List<dynamic> jsonList = response;

        // Convert the List<dynamic> to List<DealData>
        final List<DealData> userList =
        jsonList.map((json) => DealData.fromJson(json)).toList();

        return Right(
          userList,
        );
      } on ServerException catch (exception) {
        return Left(
          ServerException(
            dioError: exception.dioError,
          ),
        );
      }
    } else {
      return Left(NoInternetException(message: "No internet connection"));
    }
  }
}
