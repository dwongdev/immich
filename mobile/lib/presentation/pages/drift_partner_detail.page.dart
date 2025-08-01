import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/domain/models/user.model.dart';
import 'package:immich_mobile/extensions/build_context_extensions.dart';
import 'package:immich_mobile/presentation/widgets/bottom_sheet/partner_detail_bottom_sheet.widget.dart';
import 'package:immich_mobile/presentation/widgets/timeline/timeline.widget.dart';
import 'package:immich_mobile/providers/infrastructure/timeline.provider.dart';
import 'package:immich_mobile/providers/infrastructure/user.provider.dart';
import 'package:immich_mobile/providers/user.provider.dart';
import 'package:immich_mobile/widgets/common/immich_toast.dart';
import 'package:immich_mobile/widgets/common/mesmerizing_sliver_app_bar.dart';

@RoutePage()
class DriftPartnerDetailPage extends StatelessWidget {
  final PartnerUserDto partner;

  const DriftPartnerDetailPage({super.key, required this.partner});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        timelineServiceProvider.overrideWith((ref) {
          final timelineService = ref.watch(timelineFactoryProvider).remoteAssets(partner.id);
          ref.onDispose(timelineService.dispose);
          return timelineService;
        }),
      ],
      child: Timeline(
        appBar: MesmerizingSliverAppBar(title: partner.name, icon: Icons.person_outline),
        topSliverWidget: _InfoBox(partner: partner),
        topSliverWidgetHeight: 110,
        bottomSheet: const PartnerDetailBottomSheet(),
      ),
    );
  }
}

class _InfoBox extends ConsumerStatefulWidget {
  final PartnerUserDto partner;

  const _InfoBox({required this.partner});

  @override
  ConsumerState<_InfoBox> createState() => _InfoBoxState();
}

class _InfoBoxState extends ConsumerState<_InfoBox> {
  bool _inTimeline = false;

  @override
  void initState() {
    super.initState();
    _inTimeline = widget.partner.inTimeline;
  }

  _toggleInTimeline() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      return;
    }

    try {
      await ref.read(partnerUsersProvider.notifier).toggleShowInTimeline(widget.partner.id, user.id);

      setState(() {
        _inTimeline = !_inTimeline;
      });
    } catch (error, stack) {
      debugPrint("Failed to toggle in timeline: $error $stack");
      ImmichToast.show(
        context: context,
        toastType: ToastType.error,
        durationInSecond: 1,
        msg: "Failed to toggle the timeline setting",
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 110,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: context.colorScheme.onSurface.withAlpha(10), width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                colors: [context.colorScheme.primary.withAlpha(10), context.colorScheme.primary.withAlpha(15)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  "Show in timeline",
                  style: context.textTheme.titleSmall?.copyWith(color: context.colorScheme.primary),
                ),
                subtitle: Text(
                  "Show photos and videos from this user in your timeline",
                  style: context.textTheme.bodyMedium,
                ),
                trailing: Switch(value: _inTimeline, onChanged: (_) => _toggleInTimeline()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
