import 'package:appel/screens/fragments/steps/my_step.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroStep extends MyStep {
  IntroStep({super.key})
      : super(
          title: (context) => AppLocalizations.of(context)!.mon_amour,
          content: (context) => Column(
            children: [
              Expanded(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(AppLocalizations.of(context)!.welcome_content)),
              ),
            ],
          ),
        );
}
