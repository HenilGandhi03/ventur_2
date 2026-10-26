import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ventur_2/models/image_credit.dart';
import 'package:ventur_2/repositories/quiz_repository.dart';

/// Shows image attribution for all levels. Satisfies the attribution terms of
/// the free image sources used by the game.
class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  late Future<List<ImageCredit>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadCredits();
  }

  Future<List<ImageCredit>> _loadCredits() async {
    final questions = await QuizRepository().getQuestions();
    final all = <ImageCredit>[];
    final seen = <String>{};
    for (final q in questions) {
      for (final c in q.imageCredits) {
        final key = c.sourceUrl.isNotEmpty ? c.sourceUrl : '${c.title}|${c.source}';
        if (seen.add(key)) all.add(c);
      }
    }
    return all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credits & Attribution'),
        leading: const BackButton(),
      ),
      body: FutureBuilder<List<ImageCredit>>(
        future: _future,
        builder: (context, snapshot) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _IntroCard(),
              const SizedBox(height: 16),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (snapshot.hasError)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Could not load the full attribution list (server unreachable). '
                    'Image sources are Wikimedia Commons and flagcdn.com.',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                )
              else ...[
                Text(
                  'Image sources (${snapshot.data!.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                ...snapshot.data!.map((c) => _CreditTile(credit: c)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'All imagery is free to use',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text(
            'Landmark photographs are served from Wikimedia Commons under free '
            'licences (CC BY, CC BY-SA, CC0 or public domain). Each entry links '
            'to its Commons file page, which carries the exact author and '
            'licence. Country flags come from flagcdn.com and are in the public '
            'domain.',
            style: TextStyle(fontSize: 13.5, color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _CreditTile extends StatelessWidget {
  final ImageCredit credit;
  const _CreditTile({required this.credit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: const Color(0xFFF6F8FA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              credit.title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              '${credit.source} · ${credit.license}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            if (credit.sourceUrl.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      credit.sourceUrl,
                      style: const TextStyle(fontSize: 11.5, color: Colors.blue),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy link',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.copy, size: 16),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: credit.sourceUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('Link copied'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
