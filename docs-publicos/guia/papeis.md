# Papéis e permissões

O sistema usa **RBAC (Role-Based Access Control)** com papéis armazenados em tabela separada, evitando escalação de privilégio. Um usuário pode acumular mais de um papel.

---

## Papéis institucionais

| Papel | Nível | O que pode fazer |
|---|---|---|
| **admin_mestre** | 1 — Máximo | Acesso total. Gerencia qualquer TAAEC de qualquer grupo, configurações, papéis, parametrização, integrações |
| **regional** | 2 — Regional | Aprova / reprova / devolve TAAECs em parecer final. Visualiza todos os grupos. Configura parametrização e pré-cadastros |
| **dme** | 3 — Grupo | Cria e submete TAAECs. Responsável pela completude. Analisa fila DME do próprio grupo |
| **chefe_grupo** (admin_grupo) | 4 — Grupo | Supervisiona atividades do grupo. Visualiza TAAECs e atribui papéis dentro do próprio grupo |
| **assistente** | 5 — Apoio | Auxilia na criação de TAAECs do seu grupo (visualização + edição assistida) |
| **membro** | 6 — Leitura | Acesso limitado à visualização das atividades autorizadas do seu grupo |

Além dos institucionais, o wizard usa o papel funcional **Responsável** — o usuário identificado como autor da TAAEC. Qualquer perfil pode ser Responsável de uma TAAEC específica.

---

## Multi-tenant por grupo

O sistema é multi-tenant: cada grupo escoteiro é isolado por **Row Level Security (RLS)** no banco. Um usuário só vê dados do seu grupo, **exceto**:

- **Regional** e **Admin Mestre** veem todos os grupos
- **Anuências de grupos convidados** — quando seu grupo é convidado para uma TAAEC multigrupo, o DME do seu grupo enxerga essa TAAEC para preencher os dados próprios

---

## O que cada papel vê no menu

| Item do menu | admin_mestre | regional | dme | chefe_grupo | assistente | membro |
|---|---|---|---|---|---|---|
| Painel | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| TAAECs (lista) | Todas | Todas | Do grupo | Do grupo | Do grupo | Do grupo (só ativas) |
| Nova TAAEC | ✅ | ✅ | ✅ | ✅ | ✅ | — |
| Chat | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Banco de Locais | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Aprovações DME | ✅ | ✅ | ✅ | ✅ | — | — |
| Aprovações Regional | ✅ | ✅ | — | — | — | — |
| Anuências (convidado) | ✅ | ✅ | ✅ | ✅ | — | — |
| Visão Geral | ✅ | ✅ | — | — | — | — |
| Grupos | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Administração | ✅ | parcial | — | parcial | — | — |
| Meu perfil | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

A tabela acima reflete o comportamento padrão; algumas seções dentro de **Administração** têm controle de acesso próprio descrito em [Administração](../configuracoes/administracao.md).

---

## Fluxo de aprovação por papel

```
Responsável  →  DME (anfitrião)  →  Regional  →  TAAEC autorizada
   (cria)         (anuência +        (parecer
                   análise)           final)
```

- **Risco BAIXO** (a partir da v1.4.0): a TAAEC **encerra automaticamente no DME** e **não vai à Regional**
- **Risco MODERADO** ou **ELEVADO**: vai obrigatoriamente para parecer da Regional
- **Multigrupo**: cada grupo convidado precisa lançar seus dados (e PAXTU detalhado) na seção **Anuências** antes do Responsável submeter à DME

Detalhe em [Aprovações](../modulos/aprovacoes.md).

---

## Como meu papel é atribuído

Três caminhos:

1. **Pré-cadastro** (recomendado para DME e Presidente): o Admin Mestre ou Regional cadastra seu e-mail e papel **antes** do seu primeiro signup. Ao se cadastrar, você já entra com o papel correto. Ver [Pré-cadastros](../configuracoes/pre-cadastros.md).
2. **Atribuição manual**: o Admin Mestre, Admin do Grupo ou Presidente adiciona o papel em [Usuários & Papéis](../configuracoes/usuarios-papeis.md).
3. **Cadastro inicial automático**: o primeiro usuário que se cadastra num grupo novo recebe papel inicial conforme regra institucional (validado pelo Admin Mestre depois).

!!! info "Como conferir meus papéis"
    Acesse **Meu perfil**. Os papéis ativos aparecem na seção **Conta & papéis**, junto com o seu e-mail e o ID interno do sistema.
