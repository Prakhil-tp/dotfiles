#!/bin/sh
# llm-lib.sh — shared helpers for talking to the local koboldcpp LLM.
# Sourced by dm-llm and llm-daily-briefing; not meant to be run directly.

LLM_URL="${LLM_URL:-http://127.0.0.1:5001}"
LLM_MODEL="${LLM_MODEL:-koboldcpp/qwen2.5-3b}"

# llm_ready — returns 0 if koboldcpp answers on its native model endpoint.
llm_ready() {
  curl -s --max-time 3 "$LLM_URL/api/v1/model" >/dev/null 2>&1
}

# llm_ask "<system prompt>" "<user prompt>" — prints the model's reply to stdout.
# JSON is assembled with jq --arg so prompt text can contain quotes/newlines safely.
# Returns non-zero (and prints nothing) on transport error or an empty/failed reply.
llm_ask() {
  _sys="$1"
  _usr="$2"
  _payload=$(
    jq -n \
      --arg model "$LLM_MODEL" \
      --arg sys "$_sys" \
      --arg usr "$_usr" \
      '{model: $model,
        temperature: 0.3,
        max_tokens: 800,
        messages: [ {role: "system", content: $sys},
                    {role: "user",   content: $usr} ]}'
  ) || return 1

  _resp=$(
    curl -s --max-time 120 \
      -H 'Content-Type: application/json' \
      -d "$_payload" \
      "$LLM_URL/v1/chat/completions"
  ) || return 1

  _out=$(printf '%s' "$_resp" | jq -r '.choices[0].message.content // empty' 2>/dev/null)
  [ -n "$_out" ] || return 1
  printf '%s\n' "$_out"
}
