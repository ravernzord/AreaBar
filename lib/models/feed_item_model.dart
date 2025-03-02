class FeedItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  bool isBookmarked;
  bool isLiked;

  FeedItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isBookmarked = false,
    this.isLiked = false,
  });
}
