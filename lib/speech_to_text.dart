import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

class STP extends StatefulWidget {
  const STP({super.key});

  @override
  State<STP> createState() => _STPState();
}

class _STPState extends State<STP> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false, isSummarizing = false;
  String _lastWords =
      """Artificial Intelligence, Machine Learning and Deep Learning
Some people think that the terms Artificial Intelligence, Machine learning and Deep Learning are the same. But these terms are different from one another. Artificial Intelligence is a broad term which can include Machine learning and Deep Learning inside it. Machine learning provides different techniques that would be helpful to achieve the goal of AI. We can say that Machine Learning can be the subset of Artificial Intelligence. However, Deep learning is the subset of Machine Learning. It is used to solve large complex problems using neural networks.
Types of Artificial Intelligence
Artificial Intelligence is broadly categorized into four types.
Reactive machines: This type of AI has short memory. They do not store previous memories. The IBM chess game program will be the perfect example of Reactive machines. Limited memory Artificial Intelligence: As the name suggests, it has limited memory. Self-driving cars are examples of Limited Memory AI. Theory of mind Artificial Intelligence: These types of AI are under processing. It aims making machines that can hold humans like emotion and thoughts. Self-aware Artificial Intelligence: These are the advanced versions of AI. It is believed that it will be more intelligent than humans. Impacts of Artificial Intelligence
Artificial Intelligence can have both positive as well as negative impacts on society. The applications of Artificial Intelligence are making human tasks much easier. This could result in loss of human jobs. The implementation cost of Artificial Intelligence is quite high and skilled workers are required for their development.
However, we are expecting a machine that could take human-like decisions but what will happen if humans lose control from them? Therefore, the impact of Artificial Intelligence is still a matter of debate in society.""";


  Future<void> getSummary(String input) async {
    try {
      final url = Uri.parse('https://transcriptor-1-axqw.onrender.com/get_summary?input=$input'); // Replace with your FastAPI endpoint URL

      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _lastWords = response.body;
          isSummarizing = false;
        });
      } else {
        setState(() {
          _lastWords = "Error: Unable to fetch summary. Status Code: ${response.statusCode}";
          isSummarizing = false;
        });
      }
    } catch (e) {
      setState(() {
        _lastWords = "Error: $e";
        isSummarizing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 21,
                left: 21,
                right: 21,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 555),
                  curve: Curves.easeOut,
                  width: isSummarizing ? size.width *  .25 : size.width,
                  height: isSummarizing ? size.width *  .25 : size.width,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(isSummarizing ? 1000 : 31)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                          duration: const Duration(milliseconds: 555),
                          curve: Curves.easeOut,
                          opacity: isSummarizing ? 0 : 1,
                          child: Markdown(data: _lastWords.replaceAll("\$@\$v=undefined-rv1\$@\$", "").replaceAll("\"", ""))),
                      AnimatedOpacity(
                          duration: const Duration(milliseconds: 555),
                          curve: Curves.easeOut,
                          opacity: isSummarizing ? 1 : 0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ),
              Positioned(
                top: size.width + 42 + 21,
                left: 21,
                right: 21,
                child: GestureDetector(
                  onTap: _speechToText.isNotListening
                      ? _startListening
                      : _stopListening,
                  child: Container(
                    width: size.width,
                    height: appBarHeight * .87,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                      child: Text(
                        _speechToText.isListening ? "Recording" : "Record",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 21),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.width + 42 + 21 + appBarHeight * .87 + 7,
                left: 21,
                right: 21,
                child: GestureDetector(
                  onTap: () {
                    getSummary(_lastWords);
                    setState(() {
                      isSummarizing = true;
                    });
                  },
                  child: Container(
                    width: size.width,
                    height: appBarHeight * .87,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                      child: Text(
                        "Summarize",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 21),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
