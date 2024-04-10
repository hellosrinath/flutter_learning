import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TennisScreen extends StatefulWidget {
  const TennisScreen({super.key});

  @override
  State<TennisScreen> createState() => _TennisScreenState();
}

class _TennisScreenState extends State<TennisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tennis Score"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Expanded(
              child: Card(
                margin: const EdgeInsets.all(24),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('tennis')
                        .doc('banvsind')
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }

                      debugPrint("tennisData: ${snapshot.data?.data()}");

                      final playerOneScore =
                          snapshot.data?.get('player1') ?? '0';
                      final playerTwoScore =
                          snapshot.data?.get('player2') ?? '0';

                      return Row(
                        children: [
                          _buildPlayerSection(
                            playerName: 'Player -1',
                            score: '$playerOneScore',
                          ),
                          const SizedBox(
                            height: 50,
                            child: VerticalDivider(),
                          ),
                          _buildPlayerSection(
                            playerName: 'Player -1',
                            score: '$playerTwoScore',
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerSection(
      {required final String playerName, required final String score}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            score,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            playerName,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
