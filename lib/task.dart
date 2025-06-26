
class Task {
  final int taskVal;
  final String taskdetails;
  final String colorVal;
  Task(this.taskdetails,this.taskVal,this.colorVal);

  Task.fromMap(Map<String, dynamic> map)
      : assert(map['taskdetails'] != null),
        assert(map['taskVal'] != null),
        assert(map['colorVal'] != null),
        taskdetails = map['taskdetails'],
        taskVal = map['taskVal'],
        colorVal=map['colorVal'];

  @override
  String toString() => "Record<$taskVal:$taskdetails>";
}