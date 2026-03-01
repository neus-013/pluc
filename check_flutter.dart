import 'dart:io';

void main() {
  if (Platform.isWindows) {
    print(
        '\n⚠️  Flutter is not configured in this system. Please install Flutter SDK before running the project.\n');
  }
}
