
import 'package:pokemon/services/api.dart';
import 'package:pokemon/services/navigation_service.dart';
import 'package:pokemon/services/sql_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: Api.initApi()),
  Provider.value(value: NavigationService()),
  Provider.value(value: SqliteService.initApi()),
];


List<SingleChildWidget> dependentServices = [
];

List<SingleChildWidget> uiConsumableProviders = [
];
