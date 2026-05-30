import 'dart:math';

String generateTarget() {
  final random = Random();
  return List.generate(5, (_) => random.nextInt(10)).join();
}