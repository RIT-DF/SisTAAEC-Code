# Sistema TAAEC — Documentação

![Sistema TAAEC](assets/screenshots/01-login.png)

**Governança, Risco e Autorização de Atividades Escoteiras** — plataforma institucional da Regional DF dos Escoteiros do Brasil, desenvolvida pela [RIT — Rede de Inovação e Transformação](https://rit.org.br). Acesse em [taaec.escoteirosdf.org.br](https://taaec.escoteirosdf.org.br/).

Esta documentação **não é só um manual de cliques**: cada seção explica para que serve a tela, quem deve usá-la e como o sistema apoia o fluxo escoteiro de autorização — da criação do Termo até a aprovação final pela Regional, passando pelo motor de risco em tempo real.

Se você acabou de chegar, comece pelos [Primeiros passos](guia/primeiros-passos.md).

---

## O que é o TAAEC

TAAEC é a sigla de **Termo de Autorização de Atividades Escoteiras e Controle** — o documento que autoriza qualquer atividade escoteira na Regional DF. O sistema reúne o processo inteiro num lugar só — do preenchimento ao arquivo — com:

- **Motor de risco em tempo real** — calcula score, ICO e proporção adulto:jovem enquanto o DME preenche o termo
- **Fluxo de aprovação em três etapas** — Responsável → DME → Regional
- **Anuências multigrupo** — grupos convidados lançam seus próprios números antes do envio
- **Carimbo digital SHA-256** — hash imutável e versionado de cada TAAEC
- **Audit log automático** — toda criação, edição e decisão é registrada por trigger no banco
- **Notificações por e-mail e Telegram** — alertas em tempo real para DME e Regional

---

## Módulos

| Módulo | Para quem | O que faz |
|---|---|---|
| [Painel](modulos/painel.md) | Todos | Cockpit com status das TAAECs, risco agregado e ações rápidas |
| [TAAECs](modulos/taaecs.md) | Responsável / DME | Lista, criação no wizard e detalhe de cada termo |
| [Motor de risco](modulos/motor-de-risco.md) | Todos (leitura) | Como o score, o ICO e a classificação são calculados |
| [Aprovações](modulos/aprovacoes.md) | DME / Regional | Fila de análise DME, parecer Regional e dashboard por status |
| [Anuências](modulos/anuencias.md) | DME (grupo convidado) | Lançar dados e PAXTU do seu grupo em TAAECs multigrupo |
| [Visão Geral](modulos/visao-geral.md) | Regional / Admin | Onde cada TAAEC está parada no ecossistema |
| [Chat](modulos/chat.md) | Todos envolvidos | Conversa atrelada a cada TAAEC, com histórico e anexos |
| [Banco de Locais](modulos/banco-locais.md) | Todos | Biblioteca colaborativa de locais para atividades |
| [Grupos](modulos/grupos.md) | Todos | Cadastro e visualização das Unidades Escoteiras Locais |
| [Sugestões](modulos/sugestoes.md) | Todos | Enviar correções/melhorias direto do balão flutuante |

---

## Meu perfil

| Item | Descrição |
|---|---|
| [Meu perfil](configuracoes/perfil.md) | Dados pessoais, registro escoteiro, grupo, e-mail e senha |

---

## Administração

Acessível a Admin Mestre, Regional e (em algumas seções) Admin de Grupo / Presidente.

| Seção | Acesso | O que faz |
|---|---|---|
| [Administração](configuracoes/administracao.md) | Variado | Página índice com todos os recursos administrativos |
| [Usuários & Papéis](configuracoes/usuarios-papeis.md) | Admin Mestre / Admin Grupo / Presidente | Atribuir papéis (Responsável, DME, Presidente, Regional, Especialista, Admin) |
| [Pré-cadastros](configuracoes/pre-cadastros.md) | Admin Mestre / Regional | Vincular e-mail a grupo + papel antes do signup |
| [Parametrização do motor](configuracoes/parametros.md) | Admin Mestre / Regional | Tabela de proporção (jovens × adultos × risco) |
| [Catálogo de atividades](configuracoes/catalogo.md) | Admin Mestre | Atividades pré-definidas e seus riscos padrão |
| [Notificações (Telegram & E-mail)](configuracoes/notificacoes.md) | Admin Mestre | Bot, chat IDs, SMTP, logs e reenvio manual |

---

## Primeiros passos e referência

- [Primeiro acesso e cadastro completo](guia/primeiros-passos.md)
- [Papéis e permissões](guia/papeis.md)
- [Glossário](guia/glossario.md)
- [Perguntas frequentes (FAQ)](guia/faq.md)

---

## Suporte

Dúvidas ou problemas? Use o balão **💬 Sugestões / Correções** que aparece no canto inferior direito de qualquer tela — sua mensagem vai direto para a administração já com a tela atual e seu usuário identificados.

Contato institucional: [suporte@rit.org.br](mailto:suporte@rit.org.br).

---

<small>Sistema TAAEC v1.4.0 · © 2026 [RIT — Rede de Inovação e Transformação](https://rit.org.br)</small>
