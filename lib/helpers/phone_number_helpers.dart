class PhoneNumberHelpers {
  static String formatPhoneNumber(String phoneNumber) {
    final countryCode = phoneNumber.substring(0, 3);
    final part1 = phoneNumber.substring(3, 8);
    final part2 = phoneNumber.substring(8, 13);
    return '$countryCode $part1 $part2';
  }

  static String removeSpaces(String phoneNumber) {
    return phoneNumber.replaceAll(' ', '');
  }
}
