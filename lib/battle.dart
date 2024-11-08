import 'dart:math'; // random
import 'dart:io';
import 'character.dart';
import 'monster.dart';

class RandomUtil {
  static final Random random = Random();
}

class Game {
  final Character character;
  List<Monster> monsters;
  Monster? monster;
  int monsterKillCount = 0;
  bool portionUsed = false;

  Game(this.character, this.monsters) {
    monster = getRandomMonster();
  }

  Monster? getRandomMonster() {
    if (monsters.isEmpty) {
      throw Exception("더 이상 싸울 몬스터가 없습니다.");
      return null;
    }
    monster = monsters[RandomUtil.random.nextInt(monsters.length)];
    return monster;
  }

  final yesRegExp = RegExp(r'^[yY](es)?$');

  // 전투 함수
  bool battle() {
    bool isRun = true;
    while (isRun && character.isAlive()) {
      while (character.isAlive() && monster!.isAlive()) {
        String? choice;
        while (choice == null) {
          stdout.write("행동을 선택하세요 (1: 공격, 2: 방어, 3: 특수 아이템 사용(공격력x2)): ");
          choice = stdin.readLineSync(); //
        }
        if (choice == "1") {
          character.attack(monster!);
          character.showStatus();
          monster!.showStatus();

          if (!monster!.isAlive()) {
            print('${monster!.name}을(를) 물리쳤습니다!');
            monsters.remove(monster);
            monsterKillCount++;

            if (monsters.isEmpty) {
              print("더 이상 싸울 몬스터가 없습니다. 수고하셨습니다! 전투를 종료합니다.");
              return false;
            }

            print(">> 남은 몬스터 수: ${monsters.length}");
            stdout.write("다음 몬스터와 싸우시겠습니까? (y/n): ");
            String? choice = stdin.readLineSync();
            if (choice != null && yesRegExp.hasMatch(choice)) {
              print("전투를 계속합니다.");
              monster = getRandomMonster();

              print("(☉_☉) 새로운 몬스터가 나타났습니다! : ${monster!.name} 등판! (;° ロ°)");
              monster!.showStatus();
              continue;
            } else {
              isRun = false;
              return false;
            }
          }
        } else if (choice == "2") {
          character.defend(monster!);
          character.showStatus();
          monster!.showStatus();
        } else if (choice == "3") {
          if (!portionUsed) {
            character.ap *= 2;
            portionUsed = true;
            print("${character.nickName}의 공격력이 2배로 증가했습니다.");
            character.showStatus();
          } else {
            print("이미 특수 아이템을 사용했습니다. 사용할 수 없는 옵션입니다.");
          }
        } else {
          print("잘못된 입력입니다. 다시 입력하세요.");
          continue;
        }

        if (monster!.isAlive()) {
          monster!.attack(character);
          character.showStatus();
          monster!.showStatus();
          if (!character.isAlive()) {
            print("  ,,..,,,띠로리... ${character.nickName} 사망... x_x");
            // character.showStatus();
            // monster!.showStatus();
            return false;
          }
        }
      }
    }
    return isRun;
  }
}

Future<GameResult?> startGame() async {
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
    return null;
  }
  character.showStatus();
  int chance = RandomUtil.random.nextInt(10);

  if (chance < 3) {
    character.hp += 10;
    print("보너스 체력을 얻었습니다! 현재 체력: ${character.hp}");
  }

  List<Monster> monsters = await loadMonster("./monsters.txt");
  if (monsters.isEmpty) {
    print('monsters 로드 실패');
    return null;
  }

  bool isGameRunning = true;
  Game battle = Game(character, monsters);

  while (isGameRunning && character.isAlive()) {
    print("(☉_☉) 새로운 몬스터가 나타났습니다! : ${battle.monster!.name} 등판! (;° ロ°)");
    battle.monster!.showStatus();

    isGameRunning = battle.battle();
  }

  print("전투가 종료되었습니다.");
  print("물리친 몬스터 수: ${battle.monsterKillCount}");
  print("${character.nickName}: 체력 ${character.hp}, 공격력 ${character.ap}");

  return GameResult(battle.monsterKillCount, character);
}

class GameResult {
  final int monsterKillCount;
  final Character character;

  GameResult(this.monsterKillCount, this.character);
}

void main() async {
  await startGame();
}
