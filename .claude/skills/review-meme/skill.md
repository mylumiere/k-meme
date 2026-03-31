---
name: review-meme
description: 기존 밈 파일의 품질을 검증하고 개선한다. "밈 리뷰", "밈 점검", "밈 개선", "밈 품질" 요청 시 반드시 이 스킬을 사용할 것. 인자 없이 실행하면 전체 밈을 점검한다.
user-invocable: true
allowed-tools: Agent, Bash, Read, Write, Edit, WebSearch, WebFetch
argument-hint: [meme-id 또는 "all"]
---

# 밈 리뷰 스킬

기존 밈 파일의 품질을 검증하고 개선한다.

## 실행 방식

### 단일 밈 리뷰 (인자 있을 때)

밈 리뷰어 에이전트로 특정 밈을 검증+수정한다.

```
Agent(
  name: "reviewer",
  agent: "meme-reviewer",
  model: "opus",
  prompt: "memes/$ARGUMENTS.md 파일을 리뷰하고, 품질이 부족한 부분은 직접 수정해줘."
)
```

### 전체 밈 점검 (인자 없거나 "all")

모든 밈 파일을 순회하며 형식 검증을 실행한다.

1. 먼저 빠른 형식 검증 (frontmatter, 섹션 존재 여부)을 스크립트로 수행
2. 형식 미달 파일만 리뷰어 에이전트에게 전달

## 빠른 형식 검증 스크립트

```bash
for f in memes/*.md; do
  id=$(basename "$f" .md)
  errors=""
  # frontmatter 확인
  head -10 "$f" | grep -q "^year:" || errors="$errors [year 없음]"
  head -10 "$f" | grep -q "^description:" || errors="$errors [description 없음]"
  # 섹션 확인
  grep -q "## 어휘 변환 사전" "$f" || errors="$errors [어휘 사전 없음]"
  grep -q "## 말투 규칙" "$f" || errors="$errors [말투 규칙 없음]"
  grep -q "## 변환 방식" "$f" || errors="$errors [변환 방식 없음]"
  # 어휘 사전 항목 수
  count=$(grep -c "^|" "$f" | head -1)
  [ "$count" -lt 16 ] && errors="$errors [어휘 ${count}개 < 15]"
  # 예시 수
  examples=$(grep -c "^### 입력:" "$f")
  [ "$examples" -lt 8 ] && errors="$errors [예시 ${examples}개 < 8]"
  
  if [ -n "$errors" ]; then
    echo "❌ $id:$errors"
  else
    echo "✅ $id"
  fi
done
```

## 출력

리뷰 결과 요약 테이블:

```
| 밈 ID | 형식 | 어휘 | 예시 | 점수 | 상태 |
|-------|------|------|------|------|------|
| kim-dong-hyun | ✅ | 16개 | 9개 | 9/10 | OK |
| waldo | ✅ | 15개 | 8개 | 7/10 | 개선함 |
```
