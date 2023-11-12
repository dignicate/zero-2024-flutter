import 'package:flutter_dotenv/flutter_dotenv.dart';

// Sample
Uri getBaseUrl() {
  return Uri.parse(dotenv.env['API_BASE_URL']!);
}
