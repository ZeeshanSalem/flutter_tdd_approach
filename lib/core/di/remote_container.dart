import 'package:games/ui/game_deals/data/data_source/deal_remote_data_source.dart';

import 'injection_container_common.dart';

Future<void> initRemoteDI() async {
  serviceLocator.registerLazySingleton<DealRemoteDataSource>(
    () => DealRemoteDataSourceImpl(
      networkClient: serviceLocator(),
    ),
  );
}
