import 'package:dio/dio.dart';
import 'package:games/core/error/exception.dart';
import 'package:games/core/network/network_client.dart';
import 'package:games/core/network/network_constants.dart';

abstract class DealRemoteDataSource {
  Future<dynamic> getDeals();
}

class DealRemoteDataSourceImpl extends DealRemoteDataSource {
  final NetworkClient networkClient;

  DealRemoteDataSourceImpl({
    required this.networkClient,
  });

  Future<dynamic> getDeals() async {
    var response = await networkClient.invoke(kGameDeals, RequestType.get);
    if (response.statusCode == 200 ) {
      return response.data;
    } else {
      throw ServerException(
        dioError: DioException(
          error: response,
          type: DioExceptionType.badResponse,
          requestOptions: response.requestOptions,
        ),
      );
    }
  }
}
