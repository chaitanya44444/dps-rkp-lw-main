import 'package:flutter/material.dart';
import '../pages/google_trends_rss_page.dart';

class TrendsProvider with ChangeNotifier {
  List<RssItem> _trends = [];
  final List<RssItem> _likedTrends = [];
  bool _isLoading = false;
  String? _error;

  List<RssItem> get trends => _trends;
  List<RssItem> get likedTrends => _likedTrends;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final RssFeedService _rssService = RssFeedService();

  int _parseApproxTraffic(String? trafficString) {
    if (trafficString == null) {
      return 0;
    }
    String cleanedString = trafficString.replaceAll('+', '');
    int parsedValue = 0;
    if (cleanedString.endsWith('B')) {
      try {
        parsedValue = (double.parse(cleanedString.replaceAll('B', '')) * 1000000000).toInt();
      } catch (e) {}
    } else if (cleanedString.endsWith('M')) {
      try {
        parsedValue = (double.parse(cleanedString.replaceAll('M', '')) * 1000000).toInt();
      } catch (e) {}
    } else if (cleanedString.endsWith('K')) {
      try {
        parsedValue = (double.parse(cleanedString.replaceAll('K', '')) * 1000).toInt();
      } catch (e) {}
    } else {
      parsedValue = int.tryParse(cleanedString) ?? 0;
    }
    return parsedValue;
  }

  Future<void> fetchTrends() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedTrends = await _rssService.fetchTrends();
      fetchedTrends.sort((a, b) {
        final trafficA = _parseApproxTraffic(a.approxTraffic);
        final trafficB = _parseApproxTraffic(b.approxTraffic);
        return trafficB.compareTo(trafficA);
      });
      _trends = fetchedTrends;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _trends = [];
      notifyListeners();
    }
  }

  void likeTrend(RssItem trend) {
    if (!_likedTrends.contains(trend)) {
      _likedTrends.add(trend);
      notifyListeners();
    }
  }

  void unlikeTrend(RssItem trend) {
    if (_likedTrends.remove(trend)) {
      notifyListeners();
    }
  }

  bool isTrendLiked(RssItem trend) {
    return _likedTrends.contains(trend);
  }
}
