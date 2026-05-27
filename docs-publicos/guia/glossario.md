# Glossário

Termos que aparecem com frequência no sistema e nesta documentação.

| Termo | Definição |
|---|---|
| **TAAEC** | Termo de Autorização de Atividades Escoteiras e Controle — documento principal do sistema, gerado pelo wizard e versionado por hash SHA-256 |
| **DME** | Diretoria/Mestria Executiva do grupo escoteiro — responsável pela primeira análise da TAAEC e por dar anuência quando o grupo é convidado |
| **Responsável** | Usuário que cria a TAAEC. Pode ter qualquer papel institucional; é o autor funcional do termo |
| **Regional** | Nível administrativo acima dos grupos, responsável pelo parecer final em TAAECs de risco moderado ou elevado |
| **Admin Mestre** | Papel de maior privilégio. Acesso total ao sistema, todas as configurações e todos os grupos |
| **Grupo convidado** | Grupo escoteiro que participará de uma TAAEC criada por outro grupo (multigrupo). Precisa lançar seus próprios números via Anuências |
| **PAXTU** | Plano de Atividade Escoteira — documento oficial de planejamento da atividade, anexado obrigatoriamente em PDF |
| **Plano de Segurança** | Documento obrigatório com os riscos identificados, medidas de mitigação e procedimentos de emergência |
| **ICO** | Índice de Conformidade Operacional — indicador 0–100 calculado pelo motor que mede a aderência da atividade às normas operacionais |
| **Score de risco** | Pontuação numérica calculada pelo motor a partir dos fatores marcados (pernoite, ramo, distância do hospital, etc.) |
| **Proporção (adulto:jovem)** | Quantos jovens por adulto escotista. Quanto maior o risco / mais novo o ramo, mais restritiva a proporção exigida |
| **Carimbo digital SHA-256** | Hash criptográfico imutável do conteúdo integral da TAAEC, com timestamp e versão. Garante que nada foi alterado depois da geração |
| **Anuência** | Confirmação de um grupo convidado de que vai participar da atividade, com seus números e PAXTU próprios |
| **Pré-cadastro** | Cadastro de e-mail + grupo + papel feito **antes** do signup do usuário. Aplicado automaticamente quando a pessoa se cadastra |
| **Audit log** | Registro automático e imutável (via trigger PostgreSQL) de todas as operações: criação, edição, aprovação, reprovação |
| **RLS (Row Level Security)** | Mecanismo do PostgreSQL/Supabase que isola dados por grupo. Sem isso, qualquer usuário veria dados de qualquer grupo |
| **Edge Function** | Função serverless executada no Supabase. No TAAEC é usada para integrações externas (Telegram, e-mail SMTP) |
| **Ramo escoteiro** | Faixa etária do escotismo. Os ramos usados pelo motor: Lobinho (6,5–10), Escoteiro (11–14), Sênior (15–17), Pioneiro (18–22) |
| **Multigrupo** | TAAEC que envolve mais de um grupo escoteiro. Exige anuência de cada grupo convidado antes do envio à DME |
| **Filhotes** | Crianças menores que a idade de Lobinho, presentes na atividade. Exigem checkbox de responsáveis legais quando aplicável |
| **Regra crítica de override** | Condição que bloqueia automaticamente a aprovação independentemente do score (ex: atividade aquática sem salva-vidas, ausência de PAXTU) |
| **Devolver ao Responsável** | Ação da fila DME que retorna a TAAEC para correção, sem reprovar. O Responsável edita e reenvia |
| **TAAEC de TESTE** | Modo do wizard que gera um código `TESTE-AAAA-XXXXXX`, não consome o contador oficial e pode ser excluído a qualquer momento |
| **Sugestões / Correções** | Canal interno (balão flutuante no canto inferior direito de qualquer tela) para enviar feedback à administração com tela e usuário identificados automaticamente |
| **RIT** | Rede de Inovação e Transformação — organização responsável pelo desenvolvimento e operação do TAAEC |
| **UEB** | União dos Escoteiros do Brasil — organização nacional do escotismo, cujas diretrizes o TAAEC implementa |

---

## Estados da TAAEC

| Estado | Significado | Quem age |
|---|---|---|
| **Em construção** | Rascunho com o Responsável | Responsável |
| **Em análise (DME)** | Submetida, aguardando parecer da DME do grupo anfitrião | DME |
| **Em análise (Regional)** | Aprovada pela DME, aguardando parecer final da Regional | Regional |
| **Aprovada** | Autorizada — pode ser executada | — (aguarda data) |
| **Ativa** | Aprovada e ainda não realizada (no calendário) | — |
| **Reprovada / Não autorizada** | Rejeitada por DME ou Regional | Responsável (pode reabrir nova) |
| **Devolvida** | Devolvida pelo DME para correção (não reprovou — só pediu ajuste) | Responsável |

---

## Classificações de risco

| Classificação | Cor | Score | Decisão padrão |
|---|---|---|---|
| **Baixo / Reduzido** | Verde | baixo | Apto — encerra no DME (não vai à Regional) |
| **Moderado** | Amarelo | médio | Com ressalva — passa pela Regional |
| **Elevado / Alto** | Vermelho | alto | Avaliação rigorosa — pode ser bloqueada por regra crítica |
