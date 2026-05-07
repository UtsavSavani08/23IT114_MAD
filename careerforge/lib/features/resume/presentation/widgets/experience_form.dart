import 'package:flutter/material.dart';
import '../../data/models/experience_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ExperienceForm extends StatefulWidget {
  final List<ExperienceModel> experiences;
  final ValueChanged<List<ExperienceModel>> onChanged;

  const ExperienceForm({
    super.key,
    required this.experiences,
    required this.onChanged,
  });

  @override
  State<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  void _addExperience() {
    setState(() {
      widget.experiences.add(
        ExperienceModel(
          company: '',
          role: '',
          startDate: '',
        ),
      );
    });
    widget.onChanged(widget.experiences);
  }

  void _removeExperience(int index) {
    setState(() {
      widget.experiences.removeAt(index);
    });
    widget.onChanged(widget.experiences);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.experiences.length,
          itemBuilder: (context, index) {
            final exp = widget.experiences[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Experience ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.error),
                          onPressed: () => _removeExperience(index),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: 'Company',
                      controller: TextEditingController(text: exp.company)..selection = TextSelection.collapsed(offset: exp.company.length),
                      onChanged: (val) {
                        exp.company = val;
                        widget.onChanged(widget.experiences);
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: 'Role',
                      controller: TextEditingController(text: exp.role)..selection = TextSelection.collapsed(offset: exp.role.length),
                      onChanged: (val) {
                        exp.role = val;
                        widget.onChanged(widget.experiences);
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Start Date',
                            controller: TextEditingController(text: exp.startDate)..selection = TextSelection.collapsed(offset: exp.startDate.length),
                            onChanged: (val) {
                              exp.startDate = val;
                              widget.onChanged(widget.experiences);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomTextField(
                            label: 'End Date (or Present)',
                            controller: TextEditingController(text: exp.endDate)..selection = TextSelection.collapsed(offset: exp.endDate.length),
                            onChanged: (val) {
                              exp.endDate = val;
                              widget.onChanged(widget.experiences);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: 'Description',
                      controller: TextEditingController(text: exp.description)..selection = TextSelection.collapsed(offset: exp.description.length),
                      maxLines: 3,
                      onChanged: (val) {
                        exp.description = val;
                        widget.onChanged(widget.experiences);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        TextButton.icon(
          onPressed: _addExperience,
          icon: const Icon(Icons.add),
          label: const Text('Add Experience'),
        ),
      ],
    );
  }
}
