---
name: find-meme
description: 추가할만한 최신 한국 밈을 웹에서 찾아 후보를 제시한다. "밈 찾아줘", "최신 밈", "추가할만한 밈", "트렌드 밈" 요청 시 반드시 이 스킬을 사용할 것.
user-invocable: true
allowed-tools: Agent, Bash, Read, WebSearch, WebFetch
argument-hint: [연도 또는 키워드]
---

# 밈 후보 탐색

웹에서 최신 한국 밈 트렌드를 조사하고, k-meme에 추가할만한 후보를 찾아 제시한다.

## 실행

밈 스카우트 에이전트를 실행한다.

```
Agent(
  name: "scout",
  agent: "meme-scout",
  model: "opus",
  prompt: "한국 최신 밈 트렌드를 조사해서 k-meme에 추가할만한 후보를 찾아줘.
           $ARGUMENTS
           기존 밈 목록 (중복 제외): !`ls memes/*.md | xargs -I{} basename {} .md`
           적합도 '높음'인 것만 추천해줘."
)
```

## 출력

후보 목록을 테이블로 정리한다:

| 밈 이름 | 제안 ID | 연도 | 핵심 화법 | 적합도 이유 |
|---------|---------|------|-----------|------------|

추가하고 싶은 밈이 있으면 `밈 추가해줘` 또는 `/add-meme <이름>`으로 바로 생성할 수 있다고 안내한다.
