import 'dart:convert';

class ResponseGetBetList {
  ResponseGetBetList({
    this.bets,
  });

  List<ResponseBetItem>? bets;

  factory ResponseGetBetList.fromJson(Map<String, dynamic> json) =>
      ResponseGetBetList(
        bets: json["bets"] == null ? null
            : List<ResponseBetItem>.from(json["bets"].map((x) => ResponseBetItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "bets": bets,
  };
}

class ResponseBetItem {
  ResponseBetItem({
    this.betId,
    this.ticketNumber,
    this.cutOff,
    this.stallName,
    this.location,
    this.betNumber1,
    this.betNumber2,
    this.dateTimePlaced,
    this.betAmount,
    this.betPrize,
    this.encodedByUserName,
  });

  int? betId;
  String? ticketNumber;
  String? cutOff;
  String? stallName;
  String? location;
  int? betNumber1;
  int? betNumber2;
  String? dateTimePlaced;
  double? betAmount;
  double? betPrize;
  String? encodedByUserName;

  factory ResponseBetItem.fromJson(Map<String, dynamic> json) =>
      ResponseBetItem(
        betId: json["betId"] ?? 0,
        ticketNumber: json["ticketNumber"] ?? "",
        cutOff: json["cutOff"] ?? "",
        stallName: json["stallName"] ?? "",
        location: json["location"] ?? "",
        betNumber1: json["betNumber1"] ?? 0,
        betNumber2: json["betNumber2"] ?? 0,
        dateTimePlaced: json["dateTimePlaced"] ?? "",
        betAmount: json["betAmount"] ?? 0.0,
        betPrize: json["betPrize"] ?? 0.0,
        encodedByUserName: json["encodedByUserName"] ?? "",
      );

  // Map<String, dynamic> toJson() => {
  //       "success": success ?? false,
  //       "message": message ?? "",
  //     };
}
