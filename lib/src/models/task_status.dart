//
//  dart_queue
//  task_status.dart
//
//  Created by Ngonidzashe Mangudya on 13/06/2024.
//  Copyright (c) 2024 Codecraft Solutions. All rights reserved.
//

/// Enum representing the status of a task.
///
/// The status of a task can be one of the following:
/// - `pending`: The task is created but not yet started.
/// - `running`: The task is currently being executed.
/// - `failed`: The task has been executed but failed.
/// - `pendingRetry`: The task has failed but will be retried.
/// - `completed`: The task has been successfully executed.
enum TaskStatus { pending, running, failed, pendingRetry, completed }
