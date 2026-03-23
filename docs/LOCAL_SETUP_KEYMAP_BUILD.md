# Cornix ZMK 로컬 구축/키맵 수정/빌드 가이드

이 문서는 **처음 repo를 clone한 뒤** 개발 환경을 구축하고,
`config/cornix.keymap`을 수정/빌드/검증하는 방법을 정리합니다.

## 1) 처음 clone 후 구축 방법

```bash
git clone https://github.com/hitsmaxft/zmk-keyboard-cornix.git
cd zmk-keyboard-cornix

# west workspace 초기화 (manifest는 config/west.yml 사용)
west init -l config
west update
west zephyr-export
```

> 이미 `.west`가 있는 환경이면 `west update`와 `west zephyr-export`만 다시 실행하면 됩니다.

---

## 2) 키맵 파일 위치 (중요)

기본 사용자 키맵은 아래 파일을 사용합니다.

- `config/cornix.keymap`

`build.sh`는 left/right 빌드시 `-DKEYMAP_FILE`를 명시하여
**항상 `config/cornix.keymap`을 사용**하도록 설정되어 있습니다.

예외:
- reset 펌웨어는 `settings_reset` shield를 사용하므로 reset 전용 keymap이 적용됩니다.

---

## 3) keymap 수정 방법

1. `config/cornix.keymap` 파일을 열어 레이어/키 바인딩을 수정합니다.
2. 저장 후 다시 빌드합니다.

```bash
./build.sh
```

출력 산출물:
- `build/left/zephyr/zmk.uf2`
- `build/right/zephyr/zmk.uf2`
- `build/reset/zephyr/zmk.uf2`

---

## 4) build 시 실제로 사용된 keymap 경로 확인

아래 명령으로 빌드 캐시에 기록된 keymap 경로를 확인할 수 있습니다.

```bash
grep -n "KEYMAP_FILE:STRING" build/left/CMakeCache.txt
grep -n "KEYMAP_FILE:STRING" build/right/CMakeCache.txt
grep -n "KEYMAP_FILE:STRING" build/reset/CMakeCache.txt
```

정상이라면:
- left/right: `.../config/cornix.keymap`
- reset: `.../zmk/app/boards/shields/settings_reset/settings_reset.keymap`

---

## 5) 수동 west build 예시

`build.sh`를 쓰지 않고 직접 빌드할 때도 동일하게 `KEYMAP_FILE`를 지정하세요.

```bash
# right
west build -s zmk/app -b cornix_right -d build/right -- \
  -DZMK_CONFIG="$(pwd)" \
  -DKEYMAP_FILE="$(pwd)/config/cornix.keymap"

# left
west build -s zmk/app -b cornix_left -d build/left -- \
  -DZMK_CONFIG="$(pwd)" \
  -DKEYMAP_FILE="$(pwd)/config/cornix.keymap"

# reset
west build -s zmk/app -b cornix_right -d build/reset -- \
  -DZMK_CONFIG="$(pwd)" \
  -DSHIELD=settings_reset
```

---

## 6) 자주 발생하는 문제

- **변경한 keymap이 반영되지 않는 경우**
  - 빌드 캐시를 지우고 다시 빌드하세요.
  - `build.sh`는 기본적으로 `build/reset`, `build/right`, `build/left`를 삭제 후 재빌드합니다.

- **다른 keymap 파일을 임시로 테스트하고 싶은 경우**
  - `KEYMAP_FILE_PATH` 환경변수로 경로를 덮어쓸 수 있습니다.

```bash
KEYMAP_FILE_PATH="$(pwd)/config/cornix42.keymap" ./build.sh
```
