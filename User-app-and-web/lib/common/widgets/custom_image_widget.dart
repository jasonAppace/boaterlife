import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexacom_user/utill/images.dart';

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isNotification;
  final String placeholder;
  final ImageQuality imageQuality;
  final bool enableMemoryCache;
  final bool enableDiskCache;

  const CustomImageWidget({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.isNotification = false,
    this.placeholder = '',
    this.imageQuality = ImageQuality.medium,
    this.enableMemoryCache = true,
    this.enableDiskCache = true,
  });

  @override
  Widget build(BuildContext context) {
    // Get device pixel ratio for better quality calculations
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Memoize the placeholder image to avoid rebuilding it unnecessarily
    final placeholderImage = placeholder.isNotEmpty
        ? placeholder
        : Images.placeholder(context);

    // Calculate cache dimensions based on quality setting and device pixel ratio
    final cacheDimensions = _calculateCacheDimensions(devicePixelRatio);

    return CachedNetworkImage(
      imageUrl: image,
      height: height,
      width: width,
      fit: fit,

      // Memory cache settings - only apply if enabled and dimensions are reasonable
      memCacheWidth: enableMemoryCache ? cacheDimensions.memWidth : null,
      memCacheHeight: enableMemoryCache ? cacheDimensions.memHeight : null,

      // Disk cache settings - only apply if enabled
      maxWidthDiskCache: enableDiskCache ? cacheDimensions.diskWidth : null,
      maxHeightDiskCache: enableDiskCache ? cacheDimensions.diskHeight : null,

      cacheKey: image, // Explicit cache key for better cache management

      placeholder: (context, url) => _buildPlaceholder(placeholderImage),
      errorWidget: (context, url, error) => _buildPlaceholder(placeholderImage),

      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),
    );
  }

  CacheDimensions _calculateCacheDimensions(double devicePixelRatio) {
    // Base dimensions
    final baseWidth = width?.toInt();
    final baseHeight = height?.toInt();

    switch (imageQuality) {
      case ImageQuality.low:
      // Low quality: compress more aggressively
        return CacheDimensions(
          memWidth: baseWidth != null ? (baseWidth * 0.5).toInt() : null,
          memHeight: baseHeight != null ? (baseHeight * 0.5).toInt() : null,
          diskWidth: baseWidth != null ? (baseWidth * 0.7).toInt() : null,
          diskHeight: baseHeight != null ? (baseHeight * 0.7).toInt() : null,
        );

      case ImageQuality.medium:
      // Medium quality: moderate compression
        return CacheDimensions(
          memWidth: baseWidth != null ? (baseWidth * devicePixelRatio * 0.8).toInt() : null,
          memHeight: baseHeight != null ? (baseHeight * devicePixelRatio * 0.8).toInt() : null,
          diskWidth: baseWidth != null ? (baseWidth * devicePixelRatio).toInt() : null,
          diskHeight: baseHeight != null ? (baseHeight * devicePixelRatio).toInt() : null,
        );

      case ImageQuality.high:
      // High quality: minimal compression, account for device pixel ratio
        return CacheDimensions(
          memWidth: baseWidth != null ? (baseWidth * devicePixelRatio * 1.2).toInt() : null,
          memHeight: baseHeight != null ? (baseHeight * devicePixelRatio * 1.2).toInt() : null,
          diskWidth: baseWidth != null ? (baseWidth * devicePixelRatio * 1.5).toInt() : null,
          diskHeight: baseHeight != null ? (baseHeight * devicePixelRatio * 1.5).toInt() : null,
        );

      case ImageQuality.original:
      // Original quality: no compression
        return CacheDimensions(
          memWidth: null,
          memHeight: null,
          diskWidth: null,
          diskHeight: null,
        );
    }
  }

  Widget _buildPlaceholder(String placeholderImage) {
    return Image.asset(
      placeholderImage,
      height: height,
      width: width,
      fit: fit,
      // Don't apply any cache dimensions to avoid stretching
      // Let the image maintain its natural aspect ratio
    );
  }
}

// Enum to control image quality
enum ImageQuality {
  low,      // More compression, smaller memory usage, lower quality
  medium,   // Balanced compression and quality
  high,     // Less compression, higher memory usage, better quality
  original, // No compression, original image quality
}

// Helper class to organize cache dimensions
class CacheDimensions {
  final int? memWidth;
  final int? memHeight;
  final int? diskWidth;
  final int? diskHeight;

  const CacheDimensions({
    this.memWidth,
    this.memHeight,
    this.diskWidth,
    this.diskHeight,
  });
}