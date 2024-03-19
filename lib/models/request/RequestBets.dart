
import 'package:kambas/models/request/BaseRequest.dart';
import 'package:kambas/models/request/RequestBetData.dart';

class RequestBets extends BaseRequest {
  final List<RequestBetData> list;

  const RequestBets(this.list,);

  @override
  Map<String, dynamic> getData() => {
    "bets": list,
  };
}
