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
