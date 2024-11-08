import 'dart:io';
import 'package:battle_rpg_game/battle.dart';

// 전투 결과 txt 파일로 저장하는 함수
Future<void> saveResult(GameResult result) async {
  final file = File('result.txt');
  final output = '''물리친 몬스터 수: ${result.monsterKillCount} 
      ${result.character.nickName} 남은 체력: ${result.character.hp}, 공격력: ${result.character.ap}''';
  await file.writeAsString(output);
  print("전투 결과가 result.txt에 저장되었습니다.");
}

void main() async {
  GameResult? result = await startGame();

  final yesRegExp = RegExp(r'^[yY](es)?$');

  stdout.write("결과를 저장하시겠습니까? (y/n): ");
  String? choice = stdin.readLineSync();
  if (choice != null && yesRegExp.hasMatch(choice)) {
    await saveResult(result!);
  } else {
    print("결과를 저장하지 않고 종료합니다.");
  }
}
