---
name: list
description: 사용 가능한 한국 밈 목록과 활성화 상태를 보여준다
user-invocable: true
allowed-tools: Bash, Read
---

# 밈 목록 보기

사용 가능한 밈 목록과 각 밈의 활성화 상태를 보여줍니다.

## 실행

1. 아래 스크립트를 실행해서 현재 상태를 확인합니다:

```
!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/toggle-meme.sh" status "${CLAUDE_PLUGIN_DATA}" "${CLAUDE_PLUGIN_ROOT}/memes" ""`
```

2. 결과를 보기 좋게 정리해서 사용자에게 보여줍니다.
3. 각 밈의 이름과 간단한 설명을 함께 표시합니다. 밈 파일의 첫 번째 `#` 제목과 `description` 필드를 참고합니다.
4. 활성화/비활성화 방법을 안내합니다: `/k-meme:on <이름>`, `/k-meme:off <이름>`
