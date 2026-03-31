---
name: create
description: 사용자만의 커스텀 밈을 만들어 개인 디렉토리에 저장한다. 밈 이름을 지정하면 조사→작성→저장을 수행한다.
user-invocable: true
allowed-tools: Bash, Read, Write, Edit, WebSearch, WebFetch
argument-hint: <밈 이름>
---

# 커스텀 밈 만들기

사용자가 원하는 밈을 조사하고, k-meme 형식에 맞는 밈 파일을 만들어 커스텀 디렉토리에 저장합니다. 플러그인 업데이트와 무관하게 유지됩니다.

## 실행

1. 밈 이름이 없으면 어떤 밈을 만들지 물어봅니다.

2. 밈 이름이 있으면:

### Step 1: 조사

`$ARGUMENTS`에 대해 웹 검색으로 밈의 유래, 대표 표현, 말투 특성을 조사합니다.

### Step 2: 작성

기존 밈 파일을 참조해서 동일한 품질로 작성합니다:

```
!`cat "${CLAUDE_PLUGIN_ROOT}/memes/kim-dong-hyun.md"`
```

밈 파일에 포함할 것:
- frontmatter: name, year, description
- 유래
- 어휘 변환 사전 (15개+)
- 말투 규칙 (6개, 세부 매핑 포함)
- 변환 방식 (4단계)
- 입력→출력 예시 (8개+, 개발+일상 혼합)

### Step 3: 저장

커스텀 밈 디렉토리에 저장합니다:

```
!`mkdir -p "${CLAUDE_PLUGIN_DATA}/custom-memes"`
```

파일 경로: `${CLAUDE_PLUGIN_DATA}/custom-memes/<id>.md`

ID는 kebab-case 영문으로 만듭니다.

### Step 4: 안내

- 저장 완료를 알리고
- `/k-meme:on <id>`로 바로 사용 가능하다고 안내
- `/k-meme:list`에서 [커스텀] 태그로 표시된다고 안내
