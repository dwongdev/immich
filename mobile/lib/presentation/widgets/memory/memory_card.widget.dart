import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:immich_mobile/domain/models/asset/base_asset.model.dart';
import 'package:immich_mobile/extensions/build_context_extensions.dart';
import 'package:immich_mobile/presentation/widgets/asset_viewer/video_viewer.widget.dart';
import 'package:immich_mobile/presentation/widgets/images/full_image.widget.dart';
import 'package:immich_mobile/presentation/widgets/images/image_provider.dart';
import 'package:immich_mobile/utils/hooks/blurhash_hook.dart';

class DriftMemoryCard extends StatelessWidget {
  final RemoteAsset asset;
  final String title;
  final bool showTitle;
  final Function()? onVideoEnded;

  const DriftMemoryCard({
    required this.asset,
    required this.title,
    required this.showTitle,
    this.onVideoEnded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        side: BorderSide(color: Colors.black, width: 1.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          SizedBox.expand(child: _BlurredBackdrop(asset: asset)),
          LayoutBuilder(
            builder: (context, constraints) {
              // Determine the fit using the aspect ratio
              BoxFit fit = BoxFit.contain;
              if (asset.width != null && asset.height != null) {
                final aspectRatio = asset.width! / asset.height!;
                final phoneAspectRatio = constraints.maxWidth / constraints.maxHeight;
                // Look for a 25% difference in either direction
                if (phoneAspectRatio * .75 < aspectRatio && phoneAspectRatio * 1.25 > aspectRatio) {
                  // Cover to look nice if we have nearly the same aspect ratio
                  fit = BoxFit.cover;
                }
              }

              if (asset.isImage) {
                return FullImage(asset, fit: fit, size: const Size(double.infinity, double.infinity));
              } else {
                return SizedBox(
                  width: context.width,
                  height: context.height,
                  child: NativeVideoViewer(
                    key: ValueKey(asset.id),
                    asset: asset,
                    showControls: false,
                    playbackDelayFactor: 2,
                    image: FullImage(asset, size: Size(context.width, context.height), fit: BoxFit.contain),
                  ),
                );
              }
            },
          ),
          if (showTitle)
            Positioned(
              left: 18.0,
              bottom: 18.0,
              child: Text(
                title,
                style: context.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }
}

class _BlurredBackdrop extends HookWidget {
  final RemoteAsset asset;

  const _BlurredBackdrop({required this.asset});

  @override
  Widget build(BuildContext context) {
    final blurhash = useDriftBlurHashRef(asset).value;
    if (blurhash != null) {
      // Use a nice cheap blur hash image decoration
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: MemoryImage(blurhash), fit: BoxFit.cover),
        ),
        child: Container(color: Colors.black.withValues(alpha: 0.2)),
      );
    } else {
      // Fall back to using a more expensive image filtered
      // Since the ImmichImage is already precached, we can
      // safely use that as the image provider
      return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: getFullImageProvider(asset, size: Size(context.width, context.height)),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(color: Colors.black.withValues(alpha: 0.2)),
        ),
      );
    }
  }
}
