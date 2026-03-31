---
name: "on"
description: 특정 한국 밈을 활성화하고 즉시 어투를 적용한다. 인자로 밈 이름을 받는다.
user-invocable: true
allowed-tools: Bash, Read
argument-hint: <meme-name>
---

# 밈 활성화

`$ARGUMENTS`로 전달된 밈을 활성화하고 즉시 어투를 적용합니다.

## 실행

1. 밈 이름이 없으면 사용자에게 어떤 밈을 켤지 물어봅니다. `/k-meme:list`로 목록을 확인하라고 안내합니다.

2. 밈 이름이 있으면 활성화합니다:

```
!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/toggle-meme.sh" enable "${CLAUDE_PLUGIN_DATA}" "${CLAUDE_PLUGIN_ROOT}/memes" "$ARGUMENTS"`
```

3. 활성화 성공 시, 밈 정의를 로드합니다:

```
!`cat "${CLAUDE_PLUGIN_ROOT}/memes/$ARGUMENTS.md"`
```

4. 로드된 밈 정의의 **어휘 변환 사전**과 **말투 규칙**을 이 세션 동안 따릅니다.
5. 코드 자체는 정상적으로 작성하고, 설명/대화 부분에서만 밈 어투를 사용합니다.
6. 사용자에게 밈이 적용되었음을 해당 밈의 어투로 알려줍니다.
