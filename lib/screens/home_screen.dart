import 'package:dynamic_sip_flutter/constants.dart';
import 'package:dynamic_sip_flutter/controllers/dsip_controller.dart';
import 'package:dynamic_sip_flutter/widgets/sip_circular_bar.dart';
import 'package:dynamic_sip_flutter/widgets/toggleable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dsip = ref.watch(dsipController);

    final backgroudColor = useState(kAppBackgroudColor);

    // Init State
    useEffect(() {
      Future.microtask(() {
        dsip.loadSipData();
      });
      return null;
    }, []);

    // Called whenever the selected SIP changes
    useEffect(() {
      final equityValue = dsip.selectedSipData?.equity ?? 0;
      backgroudColor.value = equityValue > 50 ? Colors.orange : kAppBackgroudColor;
      return null;
    }, [dsip.selectedSipData]);

    //
    // Widgets
    //

    /// Loading Widget
    Widget _makeLoadingWidget() => const Center(
          child: CircularProgressIndicator(),
        );

    /// Error Widget
    /// - Has Retry Button
    Widget _makeErrorWidget() => Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 50,
            ),
            const SizedBox(height: 15),
            Text(
              'Error : ${dsip.error}',
              style: TextStyle(
                  color: Colors.red[300], fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextButton.icon(
              onPressed: () {
                dsip.loadSipData();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            )
          ],
        ));

    ///
    /// Date List
    ///
    Widget _makeDateList() {
      return SizedBox(
        height: 48,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: dsip.sipData.length,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            final date = dsip.sipData[index].date;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: ToggleableButton(
                child: Text(date),
                isSelected: date == dsip.selectedSipData?.date,
                onPressed: () => dsip.selectSipDataByDate(date),
              ),
            );
          },
        ),
      );
    }

    ///
    /// Widget for Sip Data's Description
    ///
    Widget _makeSipDescription() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.check_rounded),
            const SizedBox(width: 10),
            Expanded(
              child: Text(dsip.selectedSipData!.point.isEmpty
                  ? 'Buy low, Sell High'
                  : dsip.selectedSipData!.point),
            )
          ]),
          if (dsip.selectedSipData!.point.isEmpty)
            Row(children: const [
              Icon(Icons.check_rounded),
              SizedBox(width: 10),
              Text('Automatically diversify investments')
            ]),
          const SizedBox(height: 15),
        ],
      );
    }

    /// Widget
    return Stack(
      children: [
        // Seperated Background In Stack so when color changes, it will not rebuild the whole widget
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: backgroudColor.value,
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Dynamic SIP', style: TextStyle(fontSize: 18)),
            actions: [
              IconButton(splashRadius: 23, icon: const Icon(Icons.notifications), onPressed: () {}),
              IconButton(splashRadius: 23, icon: const Icon(Icons.chat_rounded), onPressed: () {}),
            ],
          ),
          backgroundColor: Colors.transparent,
          drawer: const Drawer(child: Center(child: Text("Empty Drawer"))),
          body: dsip.isLoading
              ? _makeLoadingWidget()
              : dsip.error != null
                  ? _makeErrorWidget()
                  : Column(
                      children: [
                        // SIP Bar
                        Expanded(
                          child:
                              Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            const Text('Earn more than normal SIP'),
                            SIPCircularBar(
                              equityValue: dsip.selectedSipData!.equity,
                            ),
                            Text(
                              'Personalised EquityMeter',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ]),
                        ),
                        const SizedBox(height: 30),
                        // Date List
                        _makeDateList(),
                        // Bottom Section
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Expanded(child: _makeSipDescription()),
                                // "Start Now" Button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text('Start Now'),
                                          SizedBox(width: 5),
                                          Icon(Icons.arrow_forward_rounded),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25))),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
        ),
      ],
    );
  }
}
