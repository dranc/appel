import 'package:appel/screens/fragments/footer_swiper_controller.dart';
import 'package:appel/screens/fragments/steps/intro_step.dart';
import 'package:appel/screens/fragments/steps/my_step.dart';
import 'package:appel/screens/fragments/steps/number_step.dart';
import 'package:appel/screens/fragments/steps/support_step.dart';
import 'package:appel/screens/fragments/steps/time_step.dart';
import 'package:appel/services/configure_service.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class Configure extends StatefulWidget {
  final ConfigureModel conf;
  final Function close;

  const Configure({super.key, required this.conf, required this.close});

  @override
  State<Configure> createState() => _ConfigureState();
}

class _ConfigureState extends State<Configure> {
  late ConfigureModel _conf;

  @override
  void initState() {
    _conf = widget.conf;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final steps = <MyStep>[
      IntroStep(),
      NumberStep(
        nameOfMonAmour: _conf.nameOfMonAmour,
        numberOfMonAmour: _conf.numberOfMonAmour,
        onUpdate: (conf) => setState(() {
          _conf = conf;
        }),
      ),
      TimeStep(
        waitingTime: _conf.waitingTime,
        onUpdate: (conf) => setState(() {
          _conf = conf;
        }),
      ),
      SupportStep(),
    ];

    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: footerHeight),
          child: steps[index],
        );
      },
      itemCount: steps.length,
      loop: false,
      pagination: SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          color: Colors.grey[400],
          activeColor: Colors.white,
        ),
      ),
      control: FotterSwiperController(close: widget.close),
    );
  }
}
