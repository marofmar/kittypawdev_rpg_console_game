# 텍스트 전투 게임

## 준비물

- character.txt : 캐릭터의 체력, 공격력, 방어력 정보를 담은 텍스트 파일
- monsters.txt: 캐릭터가 싸울 몬스터의 이름, 체력, 공격력 정보를 담은 텍스트 파일

## 실행 방법

dart run

## 게임 흐름

1. 캐릭터와 몬스터들의 정보를 불러옵니다.
2. 캐릭터는 몬스터 집합 중에서 랜덤으로 뽑힌 1명과 전투를 시작합니다.
3. 공격/ 방어 중에서 선택하여 캐릭터는 동작을 수행합니다.
4. 몬스터와 싸워 이기면, 해당 몬스터는 없어집니다.
5. 남은 몬스터들 중에서 랜덤으로 뽑힌 한 명과 다시 전투를 시작합니다.
6. 게임을 종료할 때 result.txt 파일에 전력을 기록할지 선택할 수 있습니다. 
