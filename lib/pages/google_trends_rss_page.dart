import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/trends_provider.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';

class RssItem {
  final String title;
  final String? link;
  final String? description;
  final DateTime? pubDate;
  final String? approxTraffic;

  RssItem({
    required this.title,
    this.link,
    this.description,
    this.pubDate,
    this.approxTraffic,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RssItem &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          link == other.link;

  @override
  int get hashCode => title.hashCode ^ link.hashCode;
}

class RssFeedService {
  final String rssFeedUrl = 'https://trends.google.com/trending/rss?geo=IN';

  Future<List<RssItem>> fetchTrends() async {
    try {
      final response = await http.get(Uri.parse(rssFeedUrl));

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final items = document.findAllElements('item');
        final entries = document.findAllElements('entry');
        final allElements = [...items, ...entries];

        return allElements.map((element) {
          final title = element.findElements('title').first.innerText;
          final linkElement = element.findElements('link').firstOrNull;
          final link = linkElement?.getAttribute('href') ?? linkElement?.innerText;
          final descriptionElement = element.findElements('description').firstOrNull ?? element.findElements('summary').firstOrNull;
          final description = descriptionElement?.innerText;
          DateTime? pubDate;
          final pubDateElement = element.findElements('pubDate').firstOrNull;
          if (pubDateElement != null) {
            try {
              pubDate = DateFormat('EEE, dd MMM HH:mm:ss \'GMT\'').parseUtc(pubDateElement.innerText).toLocal();
            } catch (e) {
              print('Error parsing date: ${pubDateElement.innerText} - $e');
            }
          }
          final approxTrafficElement = element.findElements('ht:approx_traffic').firstOrNull;
          final approxTraffic = approxTrafficElement?.innerText;

          return RssItem(
            title: title,
            link: link,
            description: description,
            pubDate: pubDate,
            approxTraffic: approxTraffic,
          );
        }).toList();
      } else {
        throw Exception('Failed to load RSS feed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching or parsing RSS feed: $e');
      throw Exception('Error loading trends: ${e.toString()}');
    }
  }
}

class GoogleTrendsRssPage extends StatefulWidget {
  const GoogleTrendsRssPage({super.key});

  @override
  _GoogleTrendsRssPageState createState() => _GoogleTrendsRssPageState();
}

class _GoogleTrendsRssPageState extends State<GoogleTrendsRssPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TrendsProvider>(context, listen: false).fetchTrends();
    });
  }

  @override
  Widget build(BuildContext context) {
    final trendsProvider = context.watch<TrendsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Trends (RSS Feed)'),
        backgroundColor: Colors.blueAccent,
      ),
      body: trendsProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : trendsProvider.error != null
              ? Center(child: Text('Error: ${trendsProvider.error}'))
              : trendsProvider.trends.isEmpty
                  ? Center(child: Text('No trends found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: trendsProvider.trends.length,
                      itemBuilder: (context, index) {
                        final trend = trendsProvider.trends[index];
                        final isLiked = trendsProvider.isTrendLiked(trend);

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (trend.pubDate != null)
                                  Text(
                                    DateFormat('MMM dd, HH:mm').format(trend.pubDate!),
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                SizedBox(height: 4.0),
                                Text(
                                  trend.title,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                if (trend.approxTraffic != null)
                                  Text(
                                    'Approx Traffic: ${trend.approxTraffic} searches',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                                      color: isLiked ? Colors.red : Colors.grey,
                                      onPressed: () {
                                        if (isLiked) {
                                          trendsProvider.unlikeTrend(trend);
                                        } else {
                                          trendsProvider.likeTrend(trend);
                                        }
                                      },
                                      tooltip: isLiked ? 'Unlike Trend' : 'Like Trend',
                                    ),
                                    if (trend.link != null)
                                      IconButton(
                                        icon: Icon(Icons.open_in_new),
                                        color: Colors.blue,
                                        onPressed: () {
                                          print('Opening link: ${trend.link}');
                                        },
                                        tooltip: 'Open Link',
                                      ),

                                  ],
                                ),

                              ],



                            ),
                          ),

                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: trendsProvider.isLoading ? null : trendsProvider.fetchTrends,
        tooltip: 'Refresh Trends',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

