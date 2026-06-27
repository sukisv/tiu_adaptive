import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/question.dart';
import 'math_text.dart';

enum OptionState { normal, selected, correct, incorrect }

class QuestionCard extends StatelessWidget {
  final Question question;
  final int index;
  final int? selectedOption;
  final bool checked;
  final void Function(int optIdx) onSelect;

  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.selectedOption,
    required this.checked,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final diffClass = _diffClass(question.difficulty);
    final correctIdx = question.opts.indexWhere((o) => o == question.answer);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Soal ${index + 1}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 6,
                  children: [
                    _DiffChip(diffClass),
                    _TagChip(question.tag),
                  ],
                ),
              ],
            ),
            if (question.topic.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                question.topic,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.muted,
                  letterSpacing: 0.2,
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Question text
            MathText(
              question.text,
              style: AppTextStyles.body(size: 15, weight: FontWeight.w500),
            ),
            const SizedBox(height: 14),
            // Options
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: List.generate(question.opts.length, (oi) {
                    final opt = question.opts[oi];
                    final label = ['A', 'B', 'C', 'D'][oi];
                    OptionState state = OptionState.normal;
                    if (checked) {
                      if (oi == correctIdx) {
                        state = OptionState.correct;
                      } else if (oi == selectedOption) {
                        state = OptionState.incorrect;
                      }
                    } else if (oi == selectedOption) {
                      state = OptionState.selected;
                    }
                    return _OptionRow(
                      label: label,
                      value: opt,
                      state: state,
                      isLast: oi == question.opts.length - 1,
                      selected: selectedOption == oi,
                      onTap: checked ? null : () => onSelect(oi),
                    );
                  }),
                ),
              ),
            ),
            // Solution box
            if (checked)
              _SolutionBox(
                isCorrect: selectedOption == correctIdx,
                correctLabel: ['A', 'B', 'C', 'D'][correctIdx],
                correctValue: question.opts[correctIdx],
                explanation: question.explanation,
              ),
          ],
        ),
      ),
    );
  }

  static String _diffClass(String d) {
    switch (d) {
      case 'mudah':
      case 'easy':
        return 'easy';
      case 'sulit':
      case 'hard':
        return 'hard';
      default:
        return 'medium';
    }
  }
}

class _OptionRow extends StatelessWidget {
  final String label;
  final String value;
  final OptionState state;
  final bool isLast;
  final bool selected;
  final VoidCallback? onTap;

  const _OptionRow({
    required this.label,
    required this.value,
    required this.state,
    required this.isLast,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.transparent;
    Color indicatorColor = AppColors.muted;
    Color textColor = AppColors.ink;
    Color borderLeft = Colors.transparent;
    IconData? trailingIcon;
    bool bold = false;

    switch (state) {
      case OptionState.selected:
        bg = AppColors.amberBg;
        indicatorColor = AppColors.gold;
        borderLeft = AppColors.gold;
        break;
      case OptionState.correct:
        bg = AppColors.greenBg;
        indicatorColor = AppColors.greenBdr;
        textColor = AppColors.greenTxt;
        borderLeft = AppColors.greenBdr;
        trailingIcon = Icons.check_circle_rounded;
        bold = true;
        break;
      case OptionState.incorrect:
        bg = AppColors.redBg;
        indicatorColor = AppColors.redBdr;
        textColor = AppColors.redTxt;
        borderLeft = AppColors.redBdr;
        trailingIcon = Icons.cancel_rounded;
        break;
      case OptionState.normal:
        break;
    }

    return Material(
      color: bg,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.gold.withValues(alpha: 0.1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: isLast ? BorderSide.none : const BorderSide(color: AppColors.divider),
              left: BorderSide(color: borderLeft, width: 3),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              // Radio indicator
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.gold : indicatorColor.withValues(alpha: 0.5),
                    width: selected ? 2 : 1.5,
                  ),
                  color: selected ? AppColors.gold : Colors.transparent,
                ),
                child: selected
                    ? const Icon(Icons.circle, size: 8, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$label.  ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      TextSpan(
                        text: value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: bold ? FontWeight.w400 : FontWeight.w400,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, color: indicatorColor, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DiffChip extends StatelessWidget {
  final String diffClass;
  const _DiffChip(this.diffClass);

  @override
  Widget build(BuildContext context) {
    Color bg, txt;
    String label;
    IconData icon;

    switch (diffClass) {
      case 'easy':
        bg = AppColors.greenBg;
        txt = AppColors.greenTxt;
        label = 'Mudah';
        icon = Icons.sentiment_satisfied_alt;
        break;
      case 'hard':
        bg = AppColors.redBg;
        txt = AppColors.redTxt;
        label = 'Sulit';
        icon = Icons.sentiment_very_dissatisfied;
        break;
      default:
        bg = AppColors.amberBg;
        txt = AppColors.amberTxt;
        label = 'Sedang';
        icon = Icons.sentiment_neutral;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: txt),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: txt)),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip(this.tag);

  @override
  Widget build(BuildContext context) {
    final isProc = tag == 'PROCGEN';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isProc ? AppColors.blueBg : AppColors.purpleBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isProc ? 'ProcGen' : 'AI · AQG',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: isProc ? AppColors.blueTxt : AppColors.purpleTxt,
        ),
      ),
    );
  }
}

class _SolutionBox extends StatelessWidget {
  final bool isCorrect;
  final String correctLabel;
  final String correctValue;
  final String? explanation;

  const _SolutionBox({
    required this.isCorrect,
    required this.correctLabel,
    required this.correctValue,
    this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        color: isCorrect ? AppColors.greenBg : AppColors.amberBg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isCorrect ? AppColors.greenBdr : AppColors.amberBdr),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
            color: isCorrect ? AppColors.greenTxt : AppColors.amberTxt,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'Jawaban Benar!' : 'Jawaban Salah',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isCorrect ? AppColors.greenTxt : AppColors.amberTxt,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.body(size: 13),
                    children: [
                      const TextSpan(text: 'Jawaban yang benar: '),
                      TextSpan(
                        text: '$correctLabel. $correctValue',
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                      if (explanation != null) ...[
                        const TextSpan(text: '\n'),
                        TextSpan(text: explanation),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
