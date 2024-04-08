import 'package:appel/screens/fragments/steps/my_step.dart';
import 'package:appel/services/configure_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class NumberStep extends MyStep {
  NumberStep({
    super.key,
    required String nameOfMonAmour,
    required String numberOfMonAmour,
    required Function(ConfigureModel conf) onUpdate,
  }) : super(
          title: (context) => AppLocalizations.of(context)!.number_title,
          content: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        nameOfMonAmour,
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        numberOfMonAmour,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  if (numberOfMonAmour.isNotEmpty)
                    IconButton(
                      onPressed: () async {
                        final conf = await ConfigureService.saveMonAmour(
                          numberOfMonAmour: '',
                          nameOfMonAmour: '',
                        );
                        onUpdate(conf);
                      },
                      icon: const Icon(Icons.clear),
                      tooltip: AppLocalizations.of(context)!.clear_selection,
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final contact =
                          await FlutterContactPicker.pickPhoneContact();
                      final conf = await ConfigureService.saveMonAmour(
                        numberOfMonAmour: contact.phoneNumber?.number ?? '',
                        nameOfMonAmour: contact.fullName ?? '',
                      );
                      onUpdate(conf);
                    } on UserCancelledPickingException {
                      // User Cancel, we don't care
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.number_choose),
                ),
              ),
            ],
          ),
        );
}
