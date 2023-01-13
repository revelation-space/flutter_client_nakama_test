import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nakama/nakama.dart';
import 'package:flutter_nakama/rtapi.dart' as rt;

class MatchArea extends StatefulWidget {
  final rt.Match match;

  const MatchArea(this.match, {Key? key}) : super(key: key);

  @override
  _MatchAreaState createState() => _MatchAreaState();
}

class _MatchAreaState extends State<MatchArea> {
  final matchDataController = TextEditingController();
  late final StreamSubscription onMatchDataSubscription;
  String matchData = '';

  @override
  void initState() {
    super.initState();

    NakamaWebsocketClient.instance.onMatchData.listen((event) {
      print(
          'received match data: ${event.data} from ${event.presence.username}');
      // Sent the match content field to received data.
      matchDataController.text = String.fromCharCodes(event.data);
    });
  }

  @override
  void dispose() {
    super.dispose();

    onMatchDataSubscription.cancel();
  }

  void sendMatchData(String data) {
    // Send dummy match data via Websocket
    NakamaWebsocketClient.instance.sendMatchData(
      matchId: widget.match.matchId,
      opCode: Int64(0),
      data: data.codeUnits,
    );
    print('Match Data changed: $data');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Welcome to ${widget.match.matchId}!'),
                const SizedBox(height: 20),
                TextField(
                  controller: matchDataController,
                  maxLines: null,
                  onChanged: sendMatchData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
