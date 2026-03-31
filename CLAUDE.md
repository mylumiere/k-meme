# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

k-meme는 Claude Code 플러그인으로, 한국 인터넷 밈/유행어의 말투로 Claude의 어투를 변환해주는 도구입니다. 사용자가 원하는 밈 하나를 선택하면 해당 캐릭터/화법 스타일로 대화합니다.

## 플러그인 구조

```
.claude-plugin/plugin.json  # 플러그인 매니페스트
skills/                      # 슬래시 커맨드 스킬
  list/SKILL.md              # /k-meme:list - 밈 목록 조회 (최신순, 년도+설명 표시)
  on/SKILL.md                # /k-meme:on <name> - 밈 활성화 + 즉시 어투 적용
  off/SKILL.md               # /k-meme:off - 밈 비활성화
  help/SKILL.md              # /k-meme:help <name> - 밈 상세 설명
memes/                       # 밈 정의 파일들 (각각 독립적인 말투 변환기)
scripts/                     # 밈 상태 관리 셸 스크립트
```

## 밈 파일 작성 규칙

`memes/<id>.md` 형식. 각 밈 파일은 다음 구조를 따른다:

```markdown
---
name: <id>
year: <유행 연도>
description: <한 줄 설명>
---

# 밈 이름

## 유래
밈의 출처, 배경

## 어휘 변환 사전
| 일반 표현 | 밈식 표현 |
~15개 항목의 변환 매핑 테이블

## 말투 규칙
6개 내외의 규칙. 각 규칙에 세부 매핑 포함 (예: 업무=경기, 동료=파트너)

## 변환 방식
1. 원래 문장의 맥락(장소, 상황, 대상)은 그대로 유지
2. 감정/평가 표현만 밈 어휘로 교체
3. 자연스러운 문장으로 출력 (낱개 어록 나열 금지)
4. 변환된 결과만 출력

## 예시
8개 이상의 입력→출력 예시 (개발 상황 + 일상 대화 혼합)
### 입력: "..."
### 출력:
...
```

핵심: **어휘 사전(~15개) + 말투 규칙(세부 매핑 포함) + 변환 방식 + 입력→출력 예시(8개+)**가 모두 필요하다. 단순 유행어가 아니라 Claude가 말투를 실제로 변환할 수 있는 수준이어야 한다.

## 밈 상태 관리

- 한 번에 하나의 밈만 활성화 가능 (섞이면 이상해짐)
- 상태는 `$CLAUDE_PLUGIN_DATA/config.json`에 `{ "active": "<meme-id>" | null }` 형태로 저장
- `scripts/toggle-meme.sh` — 상태 관리 (인자 순서: `<action> <plugin-data-dir> <memes-dir> [meme-id]`)
- `scripts/get-enabled-memes.sh` — 활성 밈 내용 출력 (인자 순서: `<plugin-data-dir> <memes-dir>`)
- list는 frontmatter의 `year` 필드로 최신순 정렬

## 테스트

```bash
# 로컬에서 플러그인 테스트
claude --plugin-dir ./

# 밈 상태 스크립트 직접 테스트
bash scripts/toggle-meme.sh status /tmp/test-data ./memes
bash scripts/toggle-meme.sh enable /tmp/test-data ./memes kim-dong-hyun
bash scripts/get-enabled-memes.sh /tmp/test-data ./memes
```

## 새 밈 추가 시

1. `memes/<id>.md` 파일 작성 (위 구조 준수)
2. id는 kebab-case 영문 (예: `kim-dong-hyun`, `lucky-vicky`)
3. frontmatter에 `name`, `year`, `description` 필수
4. 스크립트 수정 불필요 — `memes/` 디렉토리를 자동으로 스캔함
