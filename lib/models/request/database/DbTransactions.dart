class DBTransactions {
  static const DB_CREATED_DATETIME = 'created_datetime';
  static const DB_STALL_NAME = 'stall_name';
  static const DB_LOCATION = 'location';
  static const DB_TICKET_NO = 'ticket_number';
  static const DB_BET_NO_1 = 'bet_number1';
  static const DB_BET_NO_2 = 'bet_number2';
  static const DB_BET_AMOUNT = 'bet_amount';
  static const DB_BET_PRIZE = 'bet_prize';
  static const DB_USERNAME = 'encoded_by_username';

  final DateTime createdDate;
  final String stallName;
  final String location;
  final String ticketNo;
  final String betNumber1;
  final String betNumber2;
  final String betAmount;
  final String betPrize;
  final String userName;

  const DBTransactions({
    required this.createdDate,
    required this.stallName,
    required this.location,
    required this.ticketNo,
    required this.betNumber1,
    required this.betNumber2,
    required this.betAmount,
    required this.betPrize,
    required this.userName,
  });

  Map<String, String> getData() => {
        DB_CREATED_DATETIME: createdDate.toString(),
        DB_STALL_NAME: stallName,
        DB_LOCATION: location,
        DB_TICKET_NO: ticketNo,
        DB_BET_NO_1: betNumber1,
        DB_BET_NO_2: betNumber2,
        DB_BET_AMOUNT: betAmount,
        DB_BET_PRIZE: betPrize,
        DB_USERNAME: userName,
      };
}
