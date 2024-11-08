import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'character.dart';
import 'dart:math';

class Monster {
  String name;
  int hp; // health point
  int ap; // character's dp <= ap <= Max attack point
  int dp = 0; // defense point

  Monster(this.name, this.hp, this.ap);
  @override
  String toString() => 'Monster(몬스터 이름:$name, 체력:$hp, 공격력:$ap)';

  bool isAlive() => hp > 0;

  void attack(Character character) {
    print("$name의 턴");
    int damage = max(0, ap - character.dp);
    character.hp -= damage;
    print("몬스터 $name이(가) ${character.nickName}에게 $damage의 피해를 입혔습니다!");
  }

  void showStatus() {
    print("$name - 체력:${hp} 공격력:${ap}");
    print('');
  }
}

Future<List<Monster>> loadMonster(String fileName) async {
  List<Monster> monsters = [];
  try {
    List<String> contents = await File(fileName).readAsLines();
    for (String content in contents) {
      List<String> line = content.split(',');
      String name = line[0].trim();
      int hp = int.parse(line[1].trim());
      int ap = int.parse(line[2].trim());

      monsters.add(Monster(name, hp, ap));
    }
    return monsters;
  } catch (e) {
    print("fail to load Monsters: $e");
    return [];
  }
}

void main() async {
  List<Monster> monsters = await loadMonster("./monsters.txt");
  if (monsters.isNotEmpty) {
    for (var monster in monsters) {
      print(monster);
      monster.showStatus();
    }
  } else {
    print('fail');
  }
}
