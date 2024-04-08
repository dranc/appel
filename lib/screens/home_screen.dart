import 'dart:async';

import 'package:appel/screens/fragments/call.dart';
import 'package:appel/screens/fragments/configure.dart';
import 'package:appel/services/configure_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<ConfigureModel> _getConf() async => await ConfigureService.getConfig();

  bool displayConfiguration = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight / 2.5,
                  width: constraints.maxWidth,
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 64.0),
                      child: SvgPicture.asset(
                        'assets/icon.svg',
                        semanticsLabel: AppLocalizations.of(context)!.mon_amour,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: FutureBuilder(
                        future: _getConf(),
                        builder: (BuildContext ctx,
                            AsyncSnapshot<ConfigureModel> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          var startCall =
                              snapshot.data!.numberOfMonAmour.isNotEmpty &&
                                  !displayConfiguration;

                          return startCall
                              ? Call(
                                  config: snapshot.data!,
                                  openConfiguration: () => {
                                    setState(() {
                                      displayConfiguration = true;
                                    })
                                  },
                                )
                              : Configure(
                                  conf: snapshot.data!,
                                  close: () => {
                                    setState(() {
                                      displayConfiguration = false;
                                    })
                                  },
                                );
                        }),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
