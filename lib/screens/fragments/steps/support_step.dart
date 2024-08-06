import 'package:appel/screens/fragments/steps/my_step.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportStep extends MyStep {
  SupportStep({super.key})
      : super(
          title: (context) => AppLocalizations.of(context)!.support_title,
          content: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.support_content,
                  textAlign: TextAlign.center,
                ),
              ),
              IntrinsicWidth(
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        var uri =
                            Uri.parse('market://details?id=com.a2a.appel');
                        if (!await canLaunchUrl(uri)) {
                          uri = Uri.parse(
                              'https://play.google.com/store/apps/details?id=com.a2a.appel');
                        }
                        await launchUrl(uri);
                      },
                      icon: const Icon(Icons.favorite),
                      label: Expanded(
                        child: Text(AppLocalizations.of(context)!.support_rate),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => launchUrl(
                        Uri.parse('https://github.com/dranc/appel'),
                      ),
                      icon: const Icon(Icons.code),
                      label: Expanded(
                        child: Text(AppLocalizations.of(context)!.see_code),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
}
