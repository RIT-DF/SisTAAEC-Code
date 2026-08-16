#!/usr/bin/env bash
# sync-code.sh — commita e envia este repositório.
#
# Nome padrão da família (V3RTECH/RIT360): em todo projeto, `sync-code.sh` é o
# script que registra o trabalho no repositório do código.
#
# Uso:
#   scripts/sync-code.sh                # mensagem automática com a data
#   scripts/sync-code.sh "mensagem"     # mensagem própria
#
# Nada a commitar não é erro: o envio segue, porque pode haver commit anterior
# ainda não enviado — e o que publica é o push, não o commit.
set -euo pipefail

ROOT="$(git -C "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" rev-parse --show-toplevel)"
cd "$ROOT"
MSG="${1:-chore: sincroniza $(date '+%Y-%m-%d %H:%M')}"

if [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -m "$MSG"
else
  echo "- Nada novo para commitar."
fi

git fetch origin --quiet || true
if git rev-parse --verify --quiet origin/main >/dev/null; then
  PEND="$(git log --oneline origin/main..HEAD)"
  [ -z "$PEND" ] && { echo "OK Nada a enviar (o servidor já tem tudo)."; exit 0; }
  echo "Commits a enviar:"; echo "$PEND" | sed 's/^/  /'
fi

git push origin main
echo "✓ SisTAAEC sincronizado com o GitHub"
