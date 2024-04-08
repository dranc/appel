import 'dart:math';

import 'package:appel/screens/fragments/steps/my_step.dart';
import 'package:appel/services/configure_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeStep extends MyStep {
  TimeStep({
    super.key,
    required int waitingTime,
    required Function(ConfigureModel conf) onUpdate,
  }) : super(
          title: (context) => AppLocalizations.of(context)!.waiting_time_title,
          content: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.waiting_time(waitingTime)),
              Slider(
                value: waitingTime.toDouble(),
                onChanged: (double newValue) async {
                  newValue = max(1, min(newValue, 9));

                  final conf =
                      await ConfigureService.saveWaitingTime(newValue.toInt());

                  onUpdate(conf);
                },
                max: 10,
              )
            ],
          ),
        );
}
