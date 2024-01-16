class AppStrings {
  static const app_name = 'Kambas';

  static const login = 'Login';

  static const password_reset = 'Password Reset';
  static const password_reset_desc = 'Enter your registered email address and we will send you a link to reset your password';
  static const submit = 'Submit';
  static const password_reset2 = 'Already Remember Your Password?';
  static const password_reset_desc2 = 'To keep connected with us please login with your account';

  //main
  static const place_bet = 'Place Bet HERE';
  static const check_out = 'Check Out';
  static const print_ticket = 'Print Ticket';
  static const reprint_ticket = 'Re-Print Ticket';
  static const other_amount = 'Other Amount';
  static const back_to_home = 'Back to Home';
  static const bet_placed = 'Bet Placed';
  static const choose_amount = 'Choose Amount';
  static const enter_amount = 'Enter Amount';

  static const chooseNumberLabel1 = 'Choose the First Number';
  static const chooseNumberLabel2 = 'Choose the Second Number';

  static const swipeLabel1 = 'Swipe to Next Page >>>';
  static const swipeLabel2 = '<<< Previous  Next >>>';


  // ERROR MESSAGES
  static const error_general_connect_timeout_msg = "Unable to connect to server. Please check your internet connectivity and try again.";
  static const error_general_no_internet_msg = "No internet connection.";
  static const error_general_throwable_msg = "Something unexpected happened. Please try again later.";
  static const error_general_inputfields_msg = "Please input email and password.";
  static const error_register_inputfields_msg = "Please input required fields.";
  static const error_login_invalidfields_msg = "Invalid email/password. Please try again.";
  static const error_login_incorrectfields_msg = "Sorry, your email or password is incorrect. Please try again.";
  static const error_login_usernotfound_msg = "User not found.";
  static const error_relogin_user_msg = "Login status has expired. Please re-login";
  static const error_invalid_password_msg = "Invalid password. Please try again.";

  //VALIDATOR MSGS
  static const validator_password_not_match = "Passwords do not match.";
  static const validator_invalid_date = "Invalid date.";
  static const validator_email_format = "Invalid email format.";
  static const validator_alphanumeric = "This field must contain letters, numbers, dashes and underscores.";
  static const validator_min_length = "Minimum length for this field is {}";
  static const validator_password_min_char = "The password must be {} characters or more.";
  static const validator_invalid_contact_number = "Please enter valid mobile number";

  //FONTS
  static const FONT_POPPINS_REGULAR = 'PoppinsRegular';
  static const FONT_POPPINS_BOLD = 'PoppinsBold';
  static const FONT_INTER_REGULAR = 'InterRegular';
  static const FONT_INTER_BOLD = 'InterBold';


  //PRINT CONSTANTS
  static const printMethod = 'printKambasReceipt';
  static const p_ticketNumber = 'ticket_number';
  static const p_betNumber = 'bet_number';
  static const p_stallName = 'stall_name';
  static const p_drawSchedule = 'draw_sched';
  static const p_betAmount = 'bet_amount';
  static const p_priceAmount = 'price_amount';
  static const p_initialDate = 'initial_date';
  static const p_processedDate = 'processed_date';
}
