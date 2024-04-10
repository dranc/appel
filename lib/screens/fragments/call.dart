import 'package:appel/services/configure_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class Call extends StatefulWidget {
  const Call(
      {super.key, required this.config, required this.openConfiguration});

  final ConfigureModel config;
  final Function openConfiguration;

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late final AppLifecycleListener _listener;

  void startCountdown() {
    controller.reset();
    controller.duration = Duration(seconds: widget.config.waitingTime);
    controller.forward();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
    );

    controller.addListener(() async {
      setState(() {});
      if (controller.value == 1) {
        controller.stop();
        await FlutterPhoneDirectCaller.callNumber(
            widget.config.numberOfMonAmour);
      }
    });

    _listener = AppLifecycleListener(onStateChange: (state) {
      if (state == AppLifecycleState.resumed) {
        startCountdown();
      }
    });

    startCountdown();
  }

  @override
  void dispose() {
    controller.dispose();
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) => controller.stop(),
      onTapCancel: () => controller.forward(),
      onTapUp: (_) => controller.forward(),
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.config.nameOfMonAmour,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(widget.config.numberOfMonAmour),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 8.0),
                    child: LinearProgressIndicator(
                      value: controller.value,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.touch_to_pause,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.red[100]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  child: const Text('VDapps.com'),
                  onTap: () => launchUrl(
                        Uri.https('vdapps.com'),
                      )),
            ),
            Container(
              height: 64,
              color: Theme.of(context).colorScheme.primary,
              child: Row(children: [
                Expanded(
                  child: Container(),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: const Icon(Icons.settings),
                  icon: Text(AppLocalizations.of(context)!.appel_settings),
                  onPressed: () {
                    widget.openConfiguration();
                  },
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
