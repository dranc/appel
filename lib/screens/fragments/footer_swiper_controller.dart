import 'package:appel/services/configure_service.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const footerHeight = 64.0;

class FotterSwiperController extends SwiperPlugin {
  FotterSwiperController({required this.close});

  final Function close;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    var isLastStep = config.activeIndex == config.itemCount - 1;
    return Positioned(
      bottom: 0,
      height: footerHeight,
      left: 0,
      right: 0,
      child: Container(
        height: footerHeight,
        color: Theme.of(context).colorScheme.primary,
        child: Row(children: [
          config.activeIndex > 0
              ? TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  icon: const Icon(Icons.navigate_before),
                  label: Text(AppLocalizations.of(context)!.previous),
                  onPressed: () async => {
                    await config.controller.previous(),
                  },
                )
              : const SizedBox.shrink(),
          Expanded(
            child: Container(),
          ),
          TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              label: isLastStep
                  ? const Icon(Icons.close)
                  : const Icon(Icons.navigate_next),
              icon: isLastStep
                  ? Text(AppLocalizations.of(context)!.over)
                  : Text(AppLocalizations.of(context)!.next),
              onPressed: () async {
                if (!isLastStep) {
                  await config.controller.next();
                  return;
                }

                var messenger = ScaffoldMessenger.of(context);
                var localizations = AppLocalizations.of(context);
                await ConfigureService.isReady()
                    ? close()
                    : messenger.showSnackBar(SnackBar(
                        content: Text(localizations!.number_choose_first),
                        action: SnackBarAction(
                            label: localizations.ok,
                            onPressed: () async => config.controller.move(1)),
                      ));
              })
        ]),
      ),
    );
  }
}
