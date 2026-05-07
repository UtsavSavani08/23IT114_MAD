import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';

class SkillsInput extends StatefulWidget {
  final List<String> skills;
  final ValueChanged<List<String>> onChanged;

  const SkillsInput({
    super.key,
    required this.skills,
    required this.onChanged,
  });

  @override
  State<SkillsInput> createState() => _SkillsInputState();
}

class _SkillsInputState extends State<SkillsInput> {
  final TextEditingController _skillController = TextEditingController();

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !widget.skills.contains(skill)) {
      setState(() {
        widget.skills.add(skill);
        _skillController.clear();
      });
      widget.onChanged(widget.skills);
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      widget.skills.remove(skill);
    });
    widget.onChanged(widget.skills);
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Add Skill (e.g. Flutter, Dart)',
                controller: _skillController,
                onSubmitted: (_) => _addSkill(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
              onPressed: _addSkill,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: widget.skills.map((skill) {
            return Chip(
              label: Text(skill),
              onDeleted: () => _removeSkill(skill),
              deleteIcon: const Icon(Icons.close, size: 18),
            );
          }).toList(),
        ),
      ],
    );
  }
}
