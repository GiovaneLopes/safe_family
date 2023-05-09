import 'dart:math';

class RandomStringGenerate {
  static String generateRandomString(int lengthOfString) {
    final random = Random();
    const allChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567890';

    final randomString = List.generate(lengthOfString,
        (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString;
  }
}
