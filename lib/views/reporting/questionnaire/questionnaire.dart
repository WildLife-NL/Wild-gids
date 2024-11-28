import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wildgids/config/theme/custom_colors.dart';
import 'package:wildgids/views/home/home.dart';
import 'package:wildgids/views/reporting/questionnaire/questionnaire_card.dart';
import 'package:wildgids/widgets/custom_scaffold.dart';
import 'package:wildlife_api_connection/models/answer.dart';
import 'package:wildlife_api_connection/models/questionnaire.dart';

class QuestionnaireView extends StatefulWidget {
  final Questionnaire questionnaire;
  final int initialPage;

  const QuestionnaireView({
    super.key,
    required this.questionnaire,
    required this.initialPage,
  });

  @override
  QuestionnaireViewState createState() => QuestionnaireViewState();
}

class QuestionnaireViewState extends State<QuestionnaireView> {
  final PageController _pageController = PageController();
  final Map<int, List<Answer>> _answers = {};

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildQuestionnairePages() {
    List<Widget> pages = [];

    if (widget.questionnaire.questions != null) {
      for (var i = 0; i < widget.questionnaire.questions!.length; i++) {
        pages.add(
          QuestionnaireCardView(
            question: widget.questionnaire.questions![i],
            onPressed: () {
              if (i != widget.questionnaire.questions!.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeView(),
                  ),
                  (route) => false,
                );
              }
            },
            goToPreviousPage: _pageController.previousPage,
            onAnswer: (int questionIndex, List<Answer> answer) {
              setState(() {
                _answers[questionIndex] = answer;
              });
            },
            buttonText: i == widget.questionnaire.questions!.length - 1
                ? "Afronden"
                : "Volgende",
            isFirst: i == 0 ? true : false,
          ),
        );
      }
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _buildQuestionnairePages(),
            ),
          ),
          const SizedBox(height: 20),
          SmoothPageIndicator(
            controller: _pageController,
            count: _buildQuestionnairePages().length,
            effect: const WormEffect(
              activeDotColor: CustomColors.primary,
            ),
            onDotClicked: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }
}
