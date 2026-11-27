Task and Schedule Item Consolidation Plan
Current State

ScheduleItemType contains:

Task
Reminder
Subscription
Personal Event
Issues

Two task systems exist.
Analytics become fragmented.
Recurrence becomes duplicated.
Calendar integration becomes inconsistent.
Future State

Tasks:

Managed only through TaskController.
Support recurrence.
Support analytics.
Support forecasting.
Schedule Items:

Reminder
Subscription
Personal Event
Migration

Phase 1: Stop creating ScheduleItemType.task.

Phase 2: Use Task entity everywhere.

Phase 3: Remove ScheduleItemType.task.

Benefits

Single source of truth.
Better recurrence architecture.
Better forecasting.
Better analytics.
Cleaner calendar integration.