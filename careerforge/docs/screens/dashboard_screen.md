# Dashboard Screen

**File**: `lib/features/dashboard/presentation/screens/dashboard_screen.dart`

## Overview
The `DashboardScreen` acts as the central hub and main shell of the CareerForge application. It provides an at-a-glance overview of the user's job search progress and acts as the root container for the application's bottom navigation.

## Key Features
- **Bottom Navigation Shell**: Uses an `IndexedStack` combined with a `BottomNavigationBar` to seamlessly switch between the Dashboard, My Resumes, Applications, and Search tabs without losing state.
- **Offline Indicator**: A dynamic, conditional banner that appears at the top of the screen when the `ConnectivityService` detects that the device is offline.
- **Top-Level Metrics**: Utilizes the `StatsCard` widget to display four key metrics powered by the `DashboardProvider`:
  - **Total Applications**: The absolute number of applications tracked.
  - **Active Applications**: Applications currently in "Applied", "Shortlisted", or "Interview" states.
  - **Selected**: The number of successful applications.
  - **Success Rate**: The percentage of total applications that resulted in a "Selected" status.
- **Visual Status Distribution**: Features an animated donut chart (`StatusChart`) built with `fl_chart` that visually breaks down the distribution of all applications by their current status.
- **Recent Applications**: A quick-access `RecentApplicationsList` showing the 5 most recently updated job applications using `ApplicationCard` components.
- **Contextual Floating Action Button**: A FAB for quickly adding a new application, which is visible only when the user is on relevant tabs.

## State Management
- Listens to `ConnectivityService` for network status.
- Listens to `DashboardProvider` to automatically trigger UI rebuilds when underlying application data is added, updated, or deleted.
