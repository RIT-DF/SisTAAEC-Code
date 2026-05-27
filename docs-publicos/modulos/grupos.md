# Grupos

A tela **Grupos** lista as **Unidades Escoteiras Locais** cadastradas na Regional DF, com numeral, nome, UF e responsáveis.

![Lista de Unidades Escoteiras Locais (grupos) cadastrados](../assets/screenshots/11-grupos.png)

---

## Para que serve

- **Visualizar** todos os grupos da Regional DF
- **Identificar** o numeral, nome completo e responsáveis de cada grupo
- **Gerenciar** grupos (criar / editar / desativar) — restrito a Admin Mestre

A lista é fundamental para o fluxo multigrupo: quando uma TAAEC envolve mais de um grupo, o Responsável seleciona os grupos convidados a partir desta base.

---

## Estrutura de um grupo

Cada grupo escoteiro tem:

| Campo | Descrição |
|---|---|
| **Numeral** | Número oficial do GE (ex: 7, 22) |
| **Nome** | Razão escoteira (ex: GRUPO EXEMPLO) |
| **Distrito** | Distrito escoteiro ao qual pertence (ex: 5º Distrito) |
| **UF** | Estado (DF, GO, etc.) |
| **Status** | Ativo / Inativo |
| **Admin do grupo** | Usuário(s) com papel `chefe_grupo` / `admin_grupo` no grupo |

---

## Multi-tenant

O sistema opera em modelo **multi-tenant**: cada grupo escoteiro tem seus dados **isolados** por Row Level Security no banco. Um usuário só vê dados do seu grupo, exceto:

- **Regional** e **Admin Mestre** veem todos os grupos
- **Anuências de grupos convidados** veem a TAAEC específica em que foram convidados

O grupo é criado automaticamente no signup do primeiro usuário (validado depois pelo Admin Mestre) ou explicitamente em [Administração → Pré-cadastros](../configuracoes/pre-cadastros.md).

---

## Diferença vs. Administração → Unidades Escoteiras Locais

A entrada **Administração → Unidades Escoteiras Locais** aponta para esta mesma página `/grupos`. A diferença é o contexto: a partir do menu **Grupos**, você está em visualização; a partir do **Administração**, você está em modo de gestão.

---

## Por onde seguir

- **[Papéis e permissões](../guia/papeis.md)** — como cada usuário se vincula a um grupo
- **[Pré-cadastros](../configuracoes/pre-cadastros.md)** — vincular um e-mail (papel + grupo) antes do signup
- **[Usuários & Papéis](../configuracoes/usuarios-papeis.md)** — atribuir papéis dentro do grupo
