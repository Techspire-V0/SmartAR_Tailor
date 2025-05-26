import 'package:smartar/data/sources/remote/config.dart';

final reqHandler = ReqHandler();
final authHttp = reqHandler.createHttpClient('/auth');
