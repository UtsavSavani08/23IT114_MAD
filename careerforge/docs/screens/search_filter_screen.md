# Search & Filter Screen

**File**: `lib/features/application/presentation/screens/search_filter_screen.dart`

## Overview
The `SearchFilterScreen` is a high-performance query interface designed to help users quickly locate specific job applications within large datasets. It combines fuzzy text search with multiple intersecting filter dimensions to drill down into the application history.

## Key Features
- **Real-Time Search Bar**: Replaces the standard AppBar with an auto-focusing `TextField`. As the user types, it triggers real-time filtering against the `companyName` and `jobRole` fields of all applications.
- **Dynamic Chip Filters**: A horizontally scrollable row of `ChoiceChip`s representing every possible `ApplicationStatus`. Selecting a chip instantly filters the list below to only show applications matching that status.
- **Date Range Picker**: An `ActionChip` that triggers the native Material `showDateRangePicker`. When a range is selected, the list filters to applications submitted strictly within that timeframe.
- **Active Filter Management**: If any filters (text, status, or date) are active, a contextual "Active Filters" header appears featuring a one-tap "Clear All" button to instantly reset the view to the default state.
- **Results List**: Displays the filtered results using the standardized `ApplicationCard` widget. If the intersection of the current filters yields zero results, it gracefully falls back to an `EmptyStateWidget`.

## State Management
- Tightly integrated with the `ApplicationProvider`. 
- Input from the text field, status chips, and date picker directly invoke the `searchApplications`, `filterByStatus`, and `filterByDateRange` methods on the provider.
- The provider handles the complex intersection logic internally via its private `_applyFilters()` method, updating the exposed `filteredApplications` list which the UI observes and renders.
