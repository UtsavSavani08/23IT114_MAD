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
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search company or role...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
            filled: false,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<ApplicationProvider>().searchApplications('');
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
      body: Consumer<ApplicationProvider>(
        builder: (context, provider, child) {
          final hasFilters = provider.activeStatusFilter != null || 
                             provider.activeDateFilter != null ||
                             provider.searchQuery.isNotEmpty;

          return Column(
            children: [
              _buildFilterChips(context, provider),
              if (hasFilters)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      const Text(
                        'Active Filters',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: provider.clearFilters,
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: provider.filteredApplications.isEmpty
                    ? const EmptyStateWidget(
                        message: 'No results found',
                        icon: Icons.search_off,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ActionChip(
            label: const Text('Date Range'),
            avatar: const Icon(Icons.calendar_today, size: 16),
            backgroundColor: provider.activeDateFilter != null ? AppColors.primary.withValues(alpha: 0.2) : null,
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDateRange: provider.activeDateFilter,
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

  Widget _buildStatusChip(BuildContext context, ApplicationProvider provider, ApplicationStatus? status, String label) {
    final isSelected = provider.activeStatusFilter == status;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            provider.filterByStatus(status);
          }
        },
      ),
    );
  }
}
