---
name: "off"
description: 특정 한국 밈을 비활성화한다. 인자로 밈 이름을 받는다.
user-invocable: true
allowed-tools: Bash, Read
argument-hint: <meme-name>
---

# 밈 비활성화

`$ARGUMENTS`로 전달된 밈을 비활성화합니다.

## 실행

1. 밈 이름이 없으면 사용자에게 어떤 밈을 끌지 물어봅니다. `/k-meme:list`로 목록을 확인하라고 안내합니다.

2. 밈 이름이 있으면 비활성화합니다:

```
!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/toggle-meme.sh" disable "${CLAUDE_PLUGIN_DATA}" "${CLAUDE_PLUGIN_ROOT}/memes" "$ARGUMENTS"`
```

3. 비활성화 결과를 사용자에게 알려줍니다.
4. 해당 밈의 어투가 이 세션에서 더 이상 적용되지 않음을 안내합니다.
