import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../viewmodels/procgen_viewmodel.dart';
import '../widgets/question_card.dart';
import '../widgets/score_summary.dart';
import '../widgets/tips_box.dart';

// ── View: owns the ViewModel, rebuilds via ListenableBuilder ─────
class ProcGenPanel extends StatefulWidget {
  const ProcGenPanel({super.key});

  @override
  State<ProcGenPanel> createState() => _ProcGenPanelState();
}

class _ProcGenPanelState extends State<ProcGenPanel> {
  late final ProcGenViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = ProcGenViewModel();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) => _ProcGenView(vm: _vm),
    );
  }
}

// ── Pure render widget — no state, no logic ──────────────────────
class _ProcGenView extends StatelessWidget {
  final ProcGenViewModel vm;

  const _ProcGenView({required this.vm});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const _InfoCard(),
              const SizedBox(height: 12),
              _ControlsCard(
                category: vm.category,
                count: vm.count,
                difficulty: vm.difficulty,
                availableCounts: vm.availableCounts,
                maxCount: vm.maxCount,
                onCategoryChanged: (v) => vm.setCategory(v!),
                onCountChanged: (v) => vm.setCount(int.parse(v!)),
                onDifficultyChanged: (v) => vm.setDifficulty(v!),
                onGenerate: vm.generate,
              ),
              if (vm.generated) ...[
                const SizedBox(height: 12),
                _ButtonsRow(
                  checked: vm.checked,
                  allAnswered: vm.allAnswered,
                  onCheck: vm.checkAnswers,
                  onReset: vm.reset,
                ),
              ],
              if (vm.checked) ...[
                const SizedBox(height: 16),
                ScoreSummary(
                  correct: vm.correctCount,
                  wrong: vm.wrongCount,
                  total: vm.questions.length,
                ),
              ],
              if (vm.generated) ...[
                const SizedBox(height: 12),
                TipsBox(category: vm.category, difficulty: vm.difficulty),
              ],
              if (!vm.generated) ...[
                const SizedBox(height: 16),
                const _EmptyState(),
              ],
            ]),
          ),
        ),
        if (vm.generated && vm.questions.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            sliver: SliverList.builder(
              itemCount: vm.questions.length,
              itemBuilder: (context, index) {
                final question = vm.questions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: QuestionCard(
                    question: question,
                    index: index,
                    selectedOption: vm.answers[index],
                    checked: vm.checked,
                    onSelect: (optIdx) => vm.selectAnswer(index, optIdx),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

// ── Sub-widgets: pure renderers, receive data + callbacks ─────────
class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.blueBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.auto_fix_high,
                color: AppColors.blueTxt,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Procedural Generation',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.blueTxt,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Soal dibuat algoritmik: angka dan variabel di-generate acak setiap sesi. '
                    'Setiap soal unik tapi pola logikanya tetap sama. Cocok untuk latihan repetitif tanpa bosan.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsCard extends StatelessWidget {
  final String category;
  final int count;
  final String difficulty;
  final List<int> availableCounts;
  final int maxCount;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onCountChanged;
  final ValueChanged<String?> onDifficultyChanged;
  final VoidCallback onGenerate;

  const _ControlsCard({
    required this.category,
    required this.count,
    required this.difficulty,
    required this.availableCounts,
    required this.maxCount,
    required this.onCategoryChanged,
    required this.onCountChanged,
    required this.onDifficultyChanged,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 540;

    final categoryField = _DropdownField(
      label: 'Kategori Soal',
      value: category,
      items: const [
        DropdownMenuItem(value: 'mixed', child: Text('Campuran (Semua Topik)')),
        DropdownMenuItem(
          value: 'arithmetic',
          child: Text('Aritmetika & Hitungan'),
        ),
        DropdownMenuItem(value: 'sequence', child: Text('Deret Angka')),
        DropdownMenuItem(value: 'algebra', child: Text('Aljabar & Persamaan')),
        DropdownMenuItem(value: 'logic', child: Text('Logika & Geometri')),
      ],
      onChanged: onCategoryChanged,
    );

    final countField = _DropdownField(
      label: 'Jumlah Soal (maks $maxCount)',
      value: count.toString(),
      items: availableCounts
          .map(
            (v) =>
                DropdownMenuItem(value: v.toString(), child: Text('$v Soal')),
          )
          .toList(),
      onChanged: onCountChanged,
    );

    final diffField = _DropdownField(
      label: 'Tingkat Kesulitan',
      value: difficulty,
      items: const [
        DropdownMenuItem(value: 'easy', child: Text('Mudah')),
        DropdownMenuItem(value: 'medium', child: Text('Sedang')),
        DropdownMenuItem(value: 'hard', child: Text('Sulit')),
      ],
      onChanged: onDifficultyChanged,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isNarrow) ...[
              categoryField,
              const SizedBox(height: 14),
              countField,
              const SizedBox(height: 14),
              diffField,
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: categoryField),
                  const SizedBox(width: 12),
                  Expanded(child: countField),
                  const SizedBox(width: 12),
                  Expanded(child: diffField),
                ],
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Generate Soal'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
      style: const TextStyle(fontSize: 14, color: AppColors.ink),
      dropdownColor: AppColors.surface,
      borderRadius: BorderRadius.circular(4),
      isExpanded: true,
    );
  }
}

class _ButtonsRow extends StatelessWidget {
  final bool checked;
  final bool allAnswered;
  final VoidCallback onCheck;
  final VoidCallback onReset;

  const _ButtonsRow({
    required this.checked,
    required this.allAnswered,
    required this.onCheck,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (!checked && allAnswered)
          FilledButton.icon(
            onPressed: onCheck,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.greenTxt,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
            icon: const Icon(Icons.check_circle_outline, size: 18),
            label: const Text('Cek Hasil'),
          ),
        if (checked)
          OutlinedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.replay, size: 18),
            label: const Text('Ulangi'),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 32),
        child: Column(
          children: [
            Icon(Icons.quiz_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Belum ada soal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pilih kategori dan kesulitan, lalu tekan Generate Soal.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}
