import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../data/models/application_model.dart';
import '../../providers/application_provider.dart';
import '../widgets/application_card.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = context.read<ApplicationProvider>().searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: 'Search company or role...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              fillColor: Colors.transparent,
              filled: false,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        context.read<ApplicationProvider>().searchApplications('');
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (val) {
              context.read<ApplicationProvider>().searchApplications(val);
              setState(() {});
            },
          ),
        ),
      ),
      body: Consumer<ApplicationProvider>(
        builder: (context, provider, child) {
          final hasFilters = provider.activeStatusFilter != null || 
                             provider.activeDateFilter != null ||
                             provider.searchQuery.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildFilterChips(context, provider),
              if (hasFilters)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      const Text(
                        'Active Filters',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: provider.clearFilters,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Clear All',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: provider.filteredApplications.isEmpty
                    ? const EmptyStateWidget(
                        message: 'No results found',
                        icon: Icons.search_off_rounded,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: provider.filteredApplications.length,
                        itemBuilder: (context, index) {
                          return ApplicationCard(
                            application: provider.filteredApplications[index],
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, ApplicationProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _buildActionChip(
            label: 'Date Range',
            icon: Icons.calendar_today_rounded,
            isSelected: provider.activeDateFilter != null,
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDateRange: provider.activeDateFilter,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: AppColors.primary,
                        onPrimary: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (range != null) {
                provider.filterByDateRange(range);
              }
            },
          ),
          const SizedBox(width: 8),
          _buildStatusChip(context, provider, null, 'All'),
          _buildStatusChip(context, provider, ApplicationStatus.applied, 'Applied'),
          _buildStatusChip(context, provider, ApplicationStatus.shortlisted, 'Shortlisted'),
          _buildStatusChip(context, provider, ApplicationStatus.interviewScheduled, 'Interview'),
          _buildStatusChip(context, provider, ApplicationStatus.rejected, 'Rejected'),
          _buildStatusChip(context, provider, ApplicationStatus.selected, 'Selected'),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ActionChip(
      label: Text(label),
      avatar: Icon(icon, size: 14, color: isSelected ? AppColors.primary : AppColors.textSecondary),
      backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Theme.of(context).cardTheme.color,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.5),
        width: 1,
      ),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onPressed: onPressed,
    );
  }

  Widget _buildStatusChip(BuildContext context, ApplicationProvider provider, ApplicationStatus? status, String label) {
    final isSelected = provider.activeStatusFilter == status;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primary.withValues(alpha: 0.1),
        backgroundColor: Theme.of(context).cardTheme.color,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        showCheckmark: false,
        onSelected: (selected) {
          if (selected) {
            provider.filterByStatus(status);
          }
        },
      ),
    );
  }
}
