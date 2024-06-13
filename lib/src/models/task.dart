//
//  dart_queue
//  task.dart
//
//  Created by Ngonidzashe Mangudya on 13/06/2024.
//  Copyright (c) 2024 Codecraft Solutions. All rights reserved.
//

import 'task_status.dart';

/// Represents a task that can be run asynchronously.
///
/// Each task has an ID, a function that returns a `Future<dynamic>`, and a
/// status. The task can be retried a certain number of times if it fails.
class Task {
  /// Creates a new task with the given ID, function, and maximum number of
  /// retries.
  Task(this.id, this.taskFunction, {this.maxRetries = 3});

  /// The ID of the task.
  final int id;

  /// The function that represents the task to be run. This function returns a
  /// `Future<dynamic>`.
  final Future<dynamic> Function() taskFunction;

  /// The current status of the task.
  TaskStatus status = TaskStatus.pending;

  /// The number of times the task has been retried.
  int retries = 0;

  /// The maximum number of times the task can be retried.
  int maxRetries;

  /// Runs the task asynchronously.
  ///
  /// If the task fails, it will be retried up to [maxRetries] times.
  /// After running, the status of the task is updated.
  Future<void> run() async {
    status = TaskStatus.running;
    try {
      await taskFunction();
      status = TaskStatus.completed;
    } catch (e) {
      status = TaskStatus.failed;
      if (retries < maxRetries) {
        status = TaskStatus.pendingRetry;
        retries++;
      }
    }
  }
}
