---
name: help
description: 특정 밈의 상세 설명을 보여준다. 유래, 말투 특성, 사용 예시 등을 확인할 수 있다.
user-invocable: true
allowed-tools: Bash, Read
argument-hint: <meme-name>
---

# 밈 상세 설명

`$ARGUMENTS`로 전달된 밈의 상세 정보를 보여줍니다.

## 실행

1. 밈 이름이 없으면 `/k-meme:list`로 목록을 먼저 확인하라고 안내합니다.

2. 밈 이름이 있으면 해당 밈 파일을 읽어서 보여줍니다:

```
!`cat "${CLAUDE_PLUGIN_ROOT}/memes/$ARGUMENTS.md" 2>/dev/null || echo "NOT_FOUND"`
```

3. NOT_FOUND가 반환되면 밈을 찾을 수 없다고 안내하고, 사용 가능한 밈 목록을 보여줍니다:

```
!`ls "${CLAUDE_PLUGIN_ROOT}/memes/"*.md 2>/dev/null | xargs -I{} basename {} .md`
```

4. 밈 파일이 있으면 내용을 보기 좋게 정리해서 보여줍니다:
   - 밈 이름과 한줄 설명
   - 유래
   - 말투 특성 요약
   - 대표 예시 2~3개
   - 활성화 방법: `/k-meme:on $ARGUMENTS`
