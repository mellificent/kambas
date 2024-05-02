
import 'package:kambas/models/request/BaseRequest.dart';
import 'package:kambas/models/request/RequestBetData.dart';

class RequestBets extends BaseRequest {
  static const KEY_NAME_BETS = "bets";
  final List<Map<String, String>> list;

  const RequestBets(this.list,);

  @override
  Map<String, dynamic> getData() => {
    "bets": list,
  };

}
