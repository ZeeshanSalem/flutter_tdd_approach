import 'package:games/ui/game_deals/data/respository_impl/deal_repository_impl.dart';

import '../../ui/game_deals/domain/repository/deal_repository.dart';
import 'injection_container_common.dart';

Future<void> initDomainDI() async {
  serviceLocator.registerLazySingleton<DealRepository>(
    () => DealRepositoryImpl(
      networkInfo: serviceLocator(),
      dealRemoteDataSource: serviceLocator(),
    ),
  );

}
