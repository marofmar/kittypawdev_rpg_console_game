import 'dart:math'; // random
import 'dart:io';
import 'character.dart';
import 'monster.dart';

class Game {
  final Character character;
  final List<Monster> monsters;
  late final Monster monster;
  final Random _random = Random();

  Game(this.character, this.monsters) {
    monster = getRandomMonster();
  }

  Monster getRandomMonster() {
    return monsters[_random.nextInt(monsters.length)];
  }

  final yesRegExp = RegExp(r'^[yY](es)?$');
  bool battle() {
    bool isRun = true;
    while (isRun && character.isAlive()) {
      while (character.isAlive() && monster.isAlive()) {
        String? choice;
        while (choice == null) {
          stdout.write("행동을 선택하세요 (1: 공격, 2: 방어): ");
          choice = stdin.readLineSync(); //
        }
        if (choice == "1") {
          character.attack(monster);
          if (!monster.isAlive()) {
            print('${monster.name}을(를) 물리쳤습니다!');
            stdout.write("다음 몬스터와 싸우시겠습니까? (y/n): ");
            String? choice = stdin.readLineSync();
            if (choice != null && yesRegExp.hasMatch(choice)) {
              print("전투를 계속합니다.");
              print("");
              return true;
            } else {
              isRun = false;
              return false;
            }
          }
        } else if (choice == "2") {
          character.defend(monster);
        } else {
          print("잘못된 입력입니다. 다시 입력하세요.");
          continue;
        }

        if (monster.isAlive()) {
          monster.attack(character);
          if (!character.isAlive()) {
            print("  ,,..,,,띠로리... ${character.nickName} 사망... x_x");
            return false;
          }
        }
      }
    }
    return isRun;
  }
}

Future<void> startGame() async {
  String? name;
  final validNameRegExp = RegExp(r'^[a-zA-Z가-힣]+$');
  while (
      name == null || name.trim().isEmpty || !validNameRegExp.hasMatch(name)) {
    stdout.write("캐릭터 이름을 입력하세요 (한글 및 영어 대소문자만 가능): ");
    name = stdin.readLineSync();

    if (name == null || name.trim().isEmpty) {
      print("캐릭터 이름을 비워둘 수 없습니다. 다시 입력해 주세요.");
    } else if (!validNameRegExp.hasMatch(name)) {
      print("한글 및 영어 대소문자만 입력 가능합니다. 다시 입력해 주세요.");
    }
  }

  Character? character = await loadCharacter("./characters.txt", name);

  if (character == null) {
    print("character 로드 실패");
    return;
  }

  List<Monster> monsters = await loadMonster("./monsters.txt");
  if (monsters.isEmpty) {
    print('monsters 로드 실패');
  }

  bool isGameRunning = true;

  while (isGameRunning && character.isAlive()) {
    Game battle = Game(character, monsters);
    print("(☉_☉) 새로운 몬스터가 나타났습니다! : ${battle.monster.name} 등판! (;° ロ°)");
    isGameRunning = battle.battle();
  }
  print("전투가 종료되었습니다.");
}

void main() async {
  await startGame();
}
