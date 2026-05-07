import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../../core/utils/validators.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/application_model.dart';
import '../../providers/application_provider.dart';
import '../../../resume/providers/resume_provider.dart';


class ApplicationEntryScreen extends StatefulWidget {
  final ApplicationModel? application;

  const ApplicationEntryScreen({super.key, this.application});

  @override
  State<ApplicationEntryScreen> createState() => _ApplicationEntryScreenState();
}

class _ApplicationEntryScreenState extends State<ApplicationEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _companyController;
  late TextEditingController _roleController;
  late TextEditingController _urlController;
  late TextEditingController _notesController;
  
  DateTime _dateApplied = DateTime.now();
  String? _selectedResumeId;
  ApplicationStatus _status = ApplicationStatus.applied;
  
  bool get isEdit => widget.application != null;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(text: widget.application?.companyName ?? '');
    _roleController = TextEditingController(text: widget.application?.jobRole ?? '');
    _urlController = TextEditingController(text: widget.application?.jobUrl ?? '');
    _notesController = TextEditingController(text: widget.application?.notes ?? '');
    
    if (widget.application != null) {
      _dateApplied = widget.application!.dateApplied;
      _selectedResumeId = widget.application!.resumeId;
      _status = widget.application!.status;
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveApplication() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ApplicationProvider>();
      
      final app = ApplicationModel(
        applicationId: isEdit ? widget.application!.applicationId : provider.generateApplicationId(),
        companyName: _companyController.text.trim(),
        jobRole: _roleController.text.trim(),
        resumeId: _selectedResumeId ?? '',
        resumeProfileName: context.read<ResumeProvider>().getResumeById(_selectedResumeId ?? '')?.profileName ?? '',
        status: _status,
        dateApplied: _dateApplied,
        lastUpdated: DateTime.now(),
        jobUrl: _urlController.text.trim(),
        notes: _notesController.text.trim(),
      );

      if (isEdit) {
        provider.updateApplication(app);
      } else {
        provider.addApplication(app);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Application' : 'New Application'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Company Name',
                controller: _companyController,
                validator: (val) => Validators.validateRequired(val, 'Field'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Job Role',
                controller: _roleController,
                validator: (val) => Validators.validateRequired(val, 'Company Name'),
              ),
              const SizedBox(height: 16),
              _buildResumeDropdown(),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Job Post URL (Optional)',
                controller: _urlController,
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    return Validators.validateUrl(val);
                  }
                  return null;
                },
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Notes (Optional)',
                controller: _notesController,
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Save',
                onPressed: _saveApplication,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumeDropdown() {
    final resumes = context.read<ResumeProvider>().resumes;
    
    // Ensure selected resume still exists, otherwise null it
    if (_selectedResumeId != null && !resumes.any((r) => r.id == _selectedResumeId)) {
      _selectedResumeId = null;
    }

    return DropdownButtonFormField<String>(
      value: _selectedResumeId,
      decoration: InputDecoration(
        labelText: 'Resume Used',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
      ),
      items: resumes.map((resume) {
        return DropdownMenuItem<String>(
          value: resume.id,
          child: Text(resume.profileName),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _selectedResumeId = val;
        });
      },
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please select a resume';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _dateApplied,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            _dateApplied = date;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date Applied',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormatter.formatDate(_dateApplied)),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
