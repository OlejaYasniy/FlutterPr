import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookCover extends StatelessWidget {
  final String? coverUrl;
  final double width;
  final double height;

  const BookCover({
    Key? key,
    this.coverUrl,
    this.width = 56,
    this.height = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (coverUrl == null || coverUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: coverUrl!,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.teal,
            ),
          ),
        ),
      ),

      errorWidget: (context, url, error) => _buildPlaceholder(
        color: Colors.red[100],
        iconColor: Colors.red[700],
      ),

      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder({Color? color, Color? iconColor}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.menu_book,
        size: width * 0.5,
        color: iconColor ?? Colors.grey[600],
      ),
    );
  }
}
