import 'dart:math';

String generateTarget(int length) {
  final random = Random();
  return List.generate(length, (_) => random.nextInt(10)).join();
}
