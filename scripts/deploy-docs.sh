#!/usr/bin/env bash
# scripts/deploy-docs.sh
# Build, preview e deploy manual da documentação MkDocs.
#
# Uso:
#   ./scripts/deploy-docs.sh setup   # cria venv e instala dependências
#   ./scripts/deploy-docs.sh serve   # roda servidor local (http://127.0.0.1:8000)
#   ./scripts/deploy-docs.sh build   # build estrito (falha em link quebrado)
#   ./scripts/deploy-docs.sh deploy  # publica via mkdocs gh-deploy (push branch gh-pages)
#   ./scripts/deploy-docs.sh push    # commit + push do conteúdo de docs-publicos para main (dispara o GitHub Actions)
#
# Pré-requisitos:
#   - Python 3.10+ (preferencialmente 3.12)
#   - git
#   - Para 'deploy' / 'push': repositório clonado com remote origin configurado e permissão de escrita

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

VENV_DIR=".venv-docs"
REQUIREMENTS_FILE="requirements-docs.txt"
DOCS_DIR="docs-publicos"
MKDOCS_YML="mkdocs.yml"

# ----- helpers -----

log()   { printf '\033[1;34m[deploy-docs]\033[0m %s\n' "$*"; }
ok()    { printf '\033[1;32m[ok]\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }
err()   { printf '\033[1;31m[erro]\033[0m %s\n' "$*" >&2; }
abort() { err "$*"; exit 1; }

require_files() {
  [[ -f "$MKDOCS_YML" ]] || abort "Não encontrei $MKDOCS_YML na raiz do repo ($REPO_ROOT). Você está rodando na pasta certa?"
  [[ -d "$DOCS_DIR"  ]] || abort "Não encontrei a pasta $DOCS_DIR na raiz do repo."
  [[ -f "$REQUIREMENTS_FILE" ]] || abort "Não encontrei $REQUIREMENTS_FILE."
}

activate_venv() {
  if [[ ! -d "$VENV_DIR" ]]; then
    abort "venv não existe ($VENV_DIR). Rode primeiro: $0 setup"
  fi
  # shellcheck disable=SC1091
  source "$VENV_DIR/bin/activate"
}

ensure_python() {
  command -v python3 >/dev/null 2>&1 || abort "python3 não está no PATH. Instale Python 3.10+."
  # Aviso se versão antiga
  local pyver
  pyver="$(python3 -c 'import sys;print("%d.%d"%sys.version_info[:2])')"
  case "$pyver" in
    3.10|3.11|3.12|3.13) : ;;
    *) warn "Python $pyver detectado. MkDocs Material recomenda 3.10+." ;;
  esac
}

# ----- comandos -----

cmd_setup() {
  require_files
  ensure_python

  if [[ -d "$VENV_DIR" ]]; then
    log "venv já existe em $VENV_DIR — pulando criação."
  else
    log "Criando venv em $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
  fi

  # shellcheck disable=SC1091
  source "$VENV_DIR/bin/activate"

  log "Atualizando pip..."
  pip install --quiet --upgrade pip

  log "Instalando dependências de $REQUIREMENTS_FILE..."
  pip install -r "$REQUIREMENTS_FILE"

  ok "Setup concluído. Próximo passo: $0 serve  (preview local)"
}

cmd_serve() {
  require_files
  activate_venv
  log "Servidor local em http://127.0.0.1:8000  (Ctrl+C para parar)"
  mkdocs serve
}

cmd_build() {
  require_files
  activate_venv
  log "Build estrito (mkdocs build --strict)..."
  mkdocs build --strict
  ok "Build OK. Saída em _site/"
}

cmd_deploy() {
  require_files
  activate_venv

  log "Confirmações antes de publicar via branch gh-pages..."
  if [[ -n "$(git status --porcelain)" ]]; then
    warn "Há mudanças não-commitadas no working tree. O deploy publica o estado ATUAL dos arquivos, não o último commit."
    read -r -p "Continuar mesmo assim? [s/N] " resp
    [[ "${resp,,}" == "s" || "${resp,,}" == "sim" ]] || abort "Cancelado."
  fi

  log "Publicando para a branch gh-pages com mkdocs gh-deploy..."
  log "ATENÇÃO: isso faz force-push na branch gh-pages."
  mkdocs gh-deploy --strict --message "docs: deploy manual via script — {sha}"
  ok "Publicado. Verifique em alguns segundos: https://rit-df.github.io/SisTAAEC/"
  warn "Lembrete: se o GitHub Pages estiver no modo 'GitHub Actions' (recomendado), prefira o comando '$0 push' — o gh-deploy usa o modo 'branch gh-pages', que é alternativo."
}

cmd_push() {
  require_files

  if [[ -z "$(git status --porcelain docs-publicos mkdocs.yml requirements-docs.txt .github/workflows/deploy-docs.yml 2>/dev/null)" ]]; then
    log "Nenhuma mudança em docs-publicos, mkdocs.yml, requirements-docs.txt ou no workflow. Nada a publicar."
    log "Para forçar um redeploy mesmo sem mudanças, rode: gh workflow run deploy-docs.yml"
    return 0
  fi

  log "Mudanças detectadas:"
  git status --short docs-publicos mkdocs.yml requirements-docs.txt .github/workflows/deploy-docs.yml

  read -r -p "Mensagem de commit (Enter para padrão 'docs: atualiza manual'): " msg
  msg="${msg:-docs: atualiza manual}"

  git add docs-publicos mkdocs.yml requirements-docs.txt .github/workflows/deploy-docs.yml 2>/dev/null || true
  git commit -m "$msg"

  log "Fazendo push para main..."
  git push origin main

  ok "Push concluído. O GitHub Actions vai rebuildar e publicar em ~1-2 min."
  log "Acompanhe em: https://github.com/RIT-DF/SisTAAEC/actions"
}

cmd_help() {
  cat <<'EOF'
Uso: scripts/deploy-docs.sh <comando>

Comandos:
  setup    Cria venv local (.venv-docs) e instala dependências (mkdocs-material).
           Roda 1x ou quando atualizar requirements-docs.txt.

  serve    Sobe servidor local em http://127.0.0.1:8000 com live-reload.
           Use durante a edição para ver mudanças no navegador instantaneamente.

  build    Roda 'mkdocs build --strict' — falha se houver link quebrado,
           arquivo não-referenciado ou erro de configuração. Use antes do push.

  push     Commit + push do conteúdo da documentação para main.
           Dispara o GitHub Actions, que rebuilda e publica em ~1-2 min.
           ESSE É O FLUXO PADRÃO depois que tudo está configurado.

  deploy   Publica diretamente para a branch gh-pages via 'mkdocs gh-deploy'.
           Use APENAS se o GitHub Pages estiver no modo 'branch gh-pages'.
           Faz force-push na gh-pages — não use sem entender o efeito.

  help     Mostra esta ajuda.

Fluxo recomendado:
  1) Editar arquivos em docs-publicos/
  2) ./scripts/deploy-docs.sh serve     # ver localmente
  3) ./scripts/deploy-docs.sh build     # validar antes do push
  4) ./scripts/deploy-docs.sh push      # publicar via GitHub Actions

EOF
}

# ----- dispatch -----

case "${1:-help}" in
  setup)  cmd_setup ;;
  serve)  cmd_serve ;;
  build)  cmd_build ;;
  push)   cmd_push ;;
  deploy) cmd_deploy ;;
  help|--help|-h) cmd_help ;;
  *) err "Comando desconhecido: $1"; cmd_help; exit 1 ;;
esac
