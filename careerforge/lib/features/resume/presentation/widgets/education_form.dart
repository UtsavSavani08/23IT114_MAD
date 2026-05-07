import 'package:flutter/material.dart';
import '../../data/models/education_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';

class EducationForm extends StatefulWidget {
  final List<EducationModel> education;
  final ValueChanged<List<EducationModel>> onChanged;

  const EducationForm({
    super.key,
    required this.education,
    required this.onChanged,
  });

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  void _addEducation() {
    setState(() {
      widget.education.add(
        EducationModel(
          institution: '',
          degree: '',
          field: '',
          startYear: '',
        ),
      );
    });
    widget.onChanged(widget.education);
  }

  void _removeEducation(int index) {
    setState(() {
      widget.education.removeAt(index);
    });
    widget.onChanged(widget.education);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.education.length,
          itemBuilder: (context, index) {
            final edu = widget.education[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Education ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.error),
                          onPressed: () => _removeEducation(index),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: 'Institution',
                      controller: TextEditingController(text: edu.institution)..selection = TextSelection.collapsed(offset: edu.institution.length),
                      onChanged: (val) {
                        edu.institution = val;
                        widget.onChanged(widget.education);
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Degree',
                            controller: TextEditingController(text: edu.degree)..selection = TextSelection.collapsed(offset: edu.degree.length),
                            onChanged: (val) {
                              edu.degree = val;
                              widget.onChanged(widget.education);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomTextField(
                            label: 'Field of Study',
                            controller: TextEditingController(text: edu.field)..selection = TextSelection.collapsed(offset: edu.field.length),
                            onChanged: (val) {
                              edu.field = val;
                              widget.onChanged(widget.education);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Start Year',
                            controller: TextEditingController(text: edu.startYear)..selection = TextSelection.collapsed(offset: edu.startYear.length),
                            onChanged: (val) {
                              edu.startYear = val;
                              widget.onChanged(widget.education);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomTextField(
                            label: 'End Year',
                            controller: TextEditingController(text: edu.endYear)..selection = TextSelection.collapsed(offset: edu.endYear.length),
                            onChanged: (val) {
                              edu.endYear = val;
                              widget.onChanged(widget.education);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: 'Grade/GPA',
                      controller: TextEditingController(text: edu.grade)..selection = TextSelection.collapsed(offset: edu.grade.length),
                      onChanged: (val) {
                        edu.grade = val;
                        widget.onChanged(widget.education);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        TextButton.icon(
          onPressed: _addEducation,
          icon: const Icon(Icons.add),
          label: const Text('Add Education'),
        ),
      ],
    );
  }
}
