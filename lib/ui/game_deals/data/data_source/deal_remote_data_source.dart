import 'package:dio/dio.dart';
import 'package:games/core/error/exception.dart';
import 'package:games/core/network/network_client.dart';
import 'package:games/core/network/network_constants.dart';

class DealRemoteDataSource {
  final NetworkClient networkClient;

  DealRemoteDataSource({
    required this.networkClient,
  });

  Future<dynamic> getDeals() async {
    var response = await networkClient.invoke(kGameDeals, RequestType.get);
    if (response.statusCode == 200 || response.statusCode == 201) {
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
