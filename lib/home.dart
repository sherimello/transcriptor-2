import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Markdown(
              data:
                  """\$@\$v=undefined-rv1\$@\$**Main Ideas and Brief Summary**\n=============================\n### Artificial Intelligence, Machine Learning, and Deep Learning\n* Artificial Intelligence (AI) is a broad term that includes Machine Learning (ML) and Deep Learning (DL)\n* ML is a subset of AI, providing techniques to achieve AI goals\n* DL is a subset of ML, using neural networks to solve complex problems\n### Types of Artificial Intelligence\n* **Reactive machines**: short memory, no storage of previous memories\n* **Limited memory AI**: limited memory, e.g., self-driving cars\n* **Theory of mind AI**: under development, aiming to mimic human emotions and thoughts\n* **Self-aware AI**: advanced, potentially more intelligent than humans\n### Impacts of Artificial Intelligence\n* **Positive**: making human tasks easier\n* **Negative**: potential job loss, high implementation cost, and loss of human control"""
                      .replaceAll("\$@\$v=undefined-rv1\$@\$", ""))),
    );
  }
}
