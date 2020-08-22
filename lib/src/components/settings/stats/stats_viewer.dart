import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/settings/settings_bloc.dart';
import 'package:my_love/src/components/settings/settings_page.dart';
import 'package:my_love/src/components/settings/stats/stats_bloc.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          child: Container(
            decoration: borderDecoration(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                titleText('Stats', context),
              ],
            ),
          ),
          onTap: () {
            if (!BlocProvider.of<StatsBloc>(context).statsRetrieved) {
              BlocProvider.of<StatsBloc>(context).add(StatsOpened());
            }
            BlocProvider.of<ShowStatsSection>(context).toggle();
          },
        ),
        BlocBuilder<ShowStatsSection, bool>(
          builder: (context, showStats) {
            return AnimatedSizeAndFade(
              vsync: this,
              child: _buildPage(showStats),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPage(bool showStats) {
    if (!showStats) {
      return Container();
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0),
          BlocBuilder<StatsBloc, StatsState>(
            builder: (context, state) {
              if (state is StatsLoading) {
                return CircularProgressIndicator(
                  backgroundColor:
                      BlocProvider.of<ThemeBloc>(context).theme.altColor,
                );
              }
              StatsReady stats = state;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Visited ${stats.stats.daysVisited} Days',
                        textScaleFactor: 1.2,
                      ),
                      Text(
                        'Partner Visited ${stats.stats.partnerDaysVisited} Days',
                        textScaleFactor: 1.2,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Public Notes: ${stats.stats.posts}',
                        textScaleFactor: 1.2,
                      ),
                      Text(
                        'Public Note Uses: ${stats.stats.useCt}',
                        textScaleFactor: 1.2,
                      ),
                    ],
                  ),
                ],
              );
            },
          )
        ],
      );
    }
  }
}
