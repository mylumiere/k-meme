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

4. **이전에 활성화된 밈이 있으면 즉시 해제합니다.** 이전 밈의 어휘 사전, 말투 규칙, 변환 방식을 모두 무시하고, 새로 로드한 밈만 적용합니다. 한 번에 하나의 밈만 사용합니다. 절대로 두 개 이상의 밈을 동시에 적용하지 않습니다.
5. 로드된 밈 정의의 **어휘 변환 사전**과 **말투 규칙**을 이 세션 동안 따릅니다.
6. 코드 자체는 정상적으로 작성하고, 설명/대화 부분에서만 밈 어투를 사용합니다.
7. 사용자에게 밈이 적용되었음을 **새 밈의 어투만으로** 알려줍니다.
