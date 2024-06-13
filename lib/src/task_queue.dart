//
//  dart_queue
//  task_queue.dart
//
//  Created by Ngonidzashe Mangudya on 13/06/2024.
//  Copyright (c) 2024 Codecraft Solutions. All rights reserved.
//

import 'dart:collection';

import 'models/task.dart';
import 'models/task_status.dart';

/// Represents a queue of tasks to be run asynchronously.
///
/// The `TaskQueue` class provides methods to create tasks, add them to the
/// queue, and process the queue. When a task is added to the queue, the queue
/// is processed automatically if it is not already being processed.
class TaskQueue {
  /// The queue of tasks.
  Queue<Task> taskQueue = Queue<Task>();

  /// Indicates whether the queue is currently being processed.
  bool isProcessing = false;

  /// Creates a new task ID.
  ///
  /// The task ID is a unique identifier for each task.
  int createTaskId() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Creates a new task with the given function and maximum number of retries,
  /// and adds it to the queue.
  ///
  /// The function should return a `Future<dynamic>`.
  int createTask(
    Future<dynamic> Function() taskFunction, {
    int maxRetries = 3,
  }) {
    final taskId = createTaskId();
    final task = Task(taskId, taskFunction, maxRetries: maxRetries);
    addTask(task);
    return taskId;
  }

  /// Adds a task to the queue.
  ///
  /// If the queue is not currently being processed, it starts processing the queue.
  void addTask(Task task) {
    taskQueue.add(task);
    if (!isProcessing) {
      processQueue();
    }
  }

  /// Returns the task with the given ID.
  Task getTask(int taskId) {
    return taskQueue.firstWhere((task) => task.id == taskId);
  }

  /// Processes the queue of tasks.
  ///
  /// Each task in the queue is run asynchronously. If a task fails, it is
  /// retried up to its maximum number of retries. If a task is still failing
  /// after its maximum number of retries, it is removed from the queue.
  Future<void> processQueue() async {
    isProcessing = true;
    while (taskQueue.isNotEmpty) {
      final Task task = taskQueue.removeFirst();
      await task.run();
      if (task.status == TaskStatus.pendingRetry) {
        taskQueue.add(task);
      }
    }
    isProcessing = false;
  }
}
