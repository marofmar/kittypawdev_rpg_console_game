import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'monster.dart';

// 예외처리 추가: 빈 문자열, 특수문자나 숫자 안됨, 한글이나 영문 대소문자만 가능.s
class Character {
  final String nickName; // 생성자에서 입력받는 변수 final
  int hp; // health point
  int ap; // attack point
  int dp; // defense point

  Character(this.nickName, this.hp, this.ap, this.dp);

  @override
  String toString() => 'Character(이름:$nickName, 체력:$hp, 공격력:$ap, 방어력:$dp)';

  bool isAlive() => hp > 0;

  void attack(Monster monster) {
    print('$nickName의 턴!');
    int damage = max(0, (ap - monster.dp) as int);
    monster.hp -= damage;
    print('໒(⊙ᴗ⊙)७ $nickName이(가) ${monster.name}에게 $damage만큼의 피해를 입혔습니다!');
  }

  void defend(Monster monster) {
    print('defend!');
    int defense = min(dp, (monster.ap - dp) as int);
    this.hp += defense;
    print('ᕙ(⇀‸↼‶)ᕗ $nickName이(가) 방어 태세를 취하여 $defense 만큼 체력을 얻었습니다.');
    print('');
  }

  void showStatus() {
    print('${this.nickName} -  체력:${this.hp} 공격력:${this.ap} 방어력:${this.dp}');
    print('');
  }
}

Future<Character?> loadCharacter(String fileName, String nickName) async {
  try {
    String contents = await File(fileName).readAsString();
    List<String> stats = contents.split(',');
    int hp = int.parse(stats[0].trim());
    int ap = int.parse(stats[1].trim());
    int dp = int.parse(stats[2].trim());

    return Character(nickName, hp, ap, dp);
  } catch (e) {
    print('fail to load Character stat: $e');
    return null;
  }
}

void main() async {
  String? name;
  while (name == null || name.isEmpty) {
    stdout.write("캐릭터 이름을 입력하세요: ");
    name = stdin.readLineSync();

    if (name == null || name.isEmpty) {
      print("캐릭터 이름을 비워둘 수 없습니다. 다시 입력해 주세요.");
    }
  }

  Character? character = await loadCharacter("./characters.txt", name);

  if (character != null) {
    //print(character);  // Instance of 'Character'
    character.showStatus();
  } else {
    print("실패");
  }
}
