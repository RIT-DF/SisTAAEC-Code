# Sistema TAAEC — Documentação

Repositório da **documentação pública** do Sistema TAAEC (Termo de Autorização de Atividades Escoteiras e Controle), da Regional DF dos Escoteiros do Brasil — desenvolvido pela [RIT — Rede de Inovação e Transformação](https://rit.org.br).

**Sistema:** [taaecregionaldf.lovable.app](https://taaecregionaldf.lovable.app/)
**Documentação publicada:** [rit-df.github.io/SisTAAEC](https://rit-df.github.io/SisTAAEC/)

---

## Estrutura do repositório

```
.
├── docs-publicos/              ← conteúdo da documentação (.md + screenshots)
│   ├── index.md                ← home
│   ├── guia/                   ← primeiros passos, papéis, glossário, FAQ
│   ├── modulos/                ← uma página por módulo do sistema
│   ├── configuracoes/          ← Meu perfil + recursos de Administração
│   └── assets/screenshots/     ← imagens das telas (1920×1080)
├── docs/                       ← documento técnico original (.docx)
├── mkdocs.yml                  ← configuração do site (MkDocs Material)
├── requirements-docs.txt       ← dependências Python para build local
├── scripts/deploy-docs.sh      ← script de setup / preview / build / push manual
└── .github/workflows/
    └── deploy-docs.yml         ← workflow automático (GitHub Actions → Pages)
```

---

## Como atualizar a documentação

### Fluxo padrão (recomendado)

1. **Edite os arquivos** em `docs-publicos/`
2. **Veja localmente** durante a edição:
   ```bash
   ./scripts/deploy-docs.sh serve     # http://127.0.0.1:8000 com live-reload
   ```
3. **Valide antes do push**:
   ```bash
   ./scripts/deploy-docs.sh build     # build estrito; falha em link quebrado
   ```
4. **Publique**:
   ```bash
   ./scripts/deploy-docs.sh push      # commit + push para main → dispara o GitHub Actions
   ```

O GitHub Actions detecta o push, rebuilda o site e publica no GitHub Pages em ~1-2 minutos.

### Comandos do script

| Comando | O que faz |
|---|---|
| `./scripts/deploy-docs.sh setup` | Cria `.venv-docs/` e instala `mkdocs-material`. Roda 1x ou ao mudar `requirements-docs.txt` |
| `./scripts/deploy-docs.sh serve` | Servidor local com live-reload em `http://127.0.0.1:8000` |
| `./scripts/deploy-docs.sh build` | Build estrito; falha se houver link quebrado |
| `./scripts/deploy-docs.sh push` | Commit + push de `docs-publicos/` para `main` (dispara Actions) |
| `./scripts/deploy-docs.sh deploy` | Publica direto na branch `gh-pages` via `mkdocs gh-deploy` (modo alternativo) |
| `./scripts/deploy-docs.sh help` | Mostra ajuda |

### Forçar redeploy sem mudanças

Pelo GitHub CLI: `gh workflow run deploy-docs.yml --repo RIT-DF/SisTAAEC`.
Ou pela interface web: aba **Actions** → workflow **Deploy MkDocs to GitHub Pages** → **Run workflow**.

---

## Configuração inicial do GitHub Pages

Configuração feita uma vez, após criar o repositório:

1. Vá em **Settings → Pages** do repositório
2. Em **Source**, escolha **GitHub Actions** (não "Deploy from a branch")
3. Faça o primeiro push da `main` com os arquivos deste repo
4. Aguarde o workflow rodar (aba **Actions**)
5. A URL pública aparece em **Settings → Pages** assim que o primeiro deploy concluir: `https://rit-df.github.io/SisTAAEC/`

!!! note
    Se preferir o modo legado (branch `gh-pages`), use `./scripts/deploy-docs.sh deploy`. Mas o modo recomendado pelo GitHub hoje é o de **GitHub Actions** (configurado acima).

---

## Pré-requisitos locais

- **Python 3.10+** (preferencialmente 3.12)
- **git** com permissão de push na `main`

Tudo mais (mkdocs, plugins, tema) é instalado em venv local por `./scripts/deploy-docs.sh setup`.

---

## Stack

- **MkDocs Material 9.5** — gerador estático e tema
- **PyMdown Extensions** — admonitions, tabbed, emoji, etc.
- **GitHub Actions** — build + deploy automático
- **GitHub Pages** — hospedagem

---

## Licença e contato

© 2026 RIT — Rede de Inovação e Transformação. Para dúvidas ou problemas, use o balão **💬 Sugestões / Correções** dentro do próprio sistema TAAEC ou contate [suporte@rit.org.br](mailto:suporte@rit.org.br).
