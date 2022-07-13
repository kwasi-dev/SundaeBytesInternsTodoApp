class TodoItem {
  bool isFinished = false;
  String description = "";
  DateTime deadline = DateTime.now();
  DateTime? completedDate;

  // New Objective is to find out if i completed
  // task BEFORE or AFTER deadline

  TodoItem(String descArgument, DateTime deadlineArgument) {
    description = descArgument;
    deadline = deadlineArgument;
  }

  String getSubtitle() {
    DateTime currentDate = DateTime.now();
    //There are 4 
    //I need to check if completed date has a value
    if (completedDate != null) {
      // I know I finished task because i have a completed date
      // I need to check if i finished task EARLY or LATE
      if (currentDate.isAfter(deadline)) {
        // Im LATE
        return "I completed the task LATE";
      } else {
        // Im EARLY
        return "I completed the task EARLY";
      }
    } else {
      // I know i did NOT finish the task, because completed date was empty
      if (currentDate.isAfter(deadline)) {
        return "I did NOT finish the task and deadline passed";
      } else {
        return "I did NOT finish the task, but I still have time to complete it";
      }
    }
  }

  void updateCompletedDate(bool isBoxChecked) {
    if (isBoxChecked == true) {
      isFinished = true;
      completedDate = DateTime.now();
    } else {
      isFinished = false;
      completedDate = null;
    }
  }
}
