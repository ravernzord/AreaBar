import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchAggregatedContent() async {
    final apiKeys = {
      'news': dotenv.env['API_KEY_NEWS'],
      'stocks': dotenv.env['API_KEY_STOCKS'],
      'sports': dotenv.env['API_KEY_SPORTS'],
      'medical': dotenv.env['API_KEY_MEDICAL'],
      'music': dotenv.env['API_KEY_MUSIC'],
      'tech': dotenv.env['API_KEY_TECH'],
      'weather': dotenv.env['API_KEY_WEATHER'],
      'politics': dotenv.env['API_KEY_POLITICS'],
      'entertainment': dotenv.env['API_KEY_ENTERTAINMENT'],
      'inventions': dotenv.env['API_KEY_INVENTIONS'],
      'stem': dotenv.env['API_KEY_STEM'],
      // Include more APIs as needed
    };

    final List<String> apiUrls = [
      'https://newsapi.example.com?apiKey=${apiKeys['news']}',
      'https://stocksapi.example.com?apiKey=${apiKeys['stocks']}',
      'https://sportsapi.example.com?apiKey=${apiKeys['sports']}',
      'https://medicalapi.example.com?apiKey=${apiKeys['medical']}',
      'https://musicapi.example.com?apiKey=${apiKeys['music']}',
      'https://techapi.example.com?apiKey=${apiKeys['tech']}',
      'https://weatherapi.example.com?apiKey=${apiKeys['weather']}',
      'https://politicsapi.example.com?apiKey=${apiKeys['politics']}',
      'https://entertainmentapi.example.com?apiKey=${apiKeys['entertainment']}',
      'https://inventionsapi.example.com?apiKey=${apiKeys['inventions']}',
      'https://stemapi.example.com?apiKey=${apiKeys['stem']}',
      // Add additional API URLs as needed
    ];

    List<Map<String, dynamic>> combinedData = [];

    try {
      for (String url in apiUrls) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          combinedData.addAll(List<Map<String, dynamic>>.from(data));
        } else {
          print('Failed to fetch data from $url');
        }
      }
    } catch (e) {
      print('Error fetching content: $e');
    }

    return combinedData;
  }
}
