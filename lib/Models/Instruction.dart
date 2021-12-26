import 'dart:math' as math;

class Instruction {
  String? uid;
  bool done;
  String description;
  bool focusOnBuild;

  Instruction({
    this.uid,
    required this.description,
    this.done = false,
    this.focusOnBuild = false,
  });

  Instruction.fromJSON(Map<String, dynamic> instruction)
      : uid = math.Random().nextInt(99999).toString(),
        description = instruction['description'],
        done = false,
        focusOnBuild = false;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'description': description,
      };
}
