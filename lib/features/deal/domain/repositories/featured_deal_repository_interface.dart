import 'package:fresh4you/interface/repo_interface.dart';

abstract class FeaturedDealRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getFeaturedDeal();
}
