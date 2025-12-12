import 'package:flutter/material.dart';

class DemoHorizontalScreen extends StatefulWidget {
  const DemoHorizontalScreen({super.key});

  @override
  State<DemoHorizontalScreen> createState() => _DemoHorizontalScreenState();
}

class _DemoHorizontalScreenState extends State<DemoHorizontalScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Горизонтальная навигация')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
                  (i) => Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _page ? Colors.teal : Colors.grey.shade400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _page = i),
              children: const [
                _DemoPage(title: 'Страница 1', hint: 'Свайп влево →'),
                _DemoPage(title: 'Страница 2', hint: '← или →'),
                _DemoPage(title: 'Страница 3', hint: '← свайп назад'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoPage extends StatelessWidget {
  final String title;
  final String hint;

  const _DemoPage({required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(hint, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
