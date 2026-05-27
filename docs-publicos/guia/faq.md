# Perguntas frequentes

## Sobre acesso e cadastro

**Cadastrei e o sistema não mostra nada — o que faço?**
Duas causas possíveis: (1) cadastro escoteiro incompleto — vá em **Meu perfil** e preencha todos os campos; (2) papel ainda não atribuído — peça ao Admin Mestre, Regional ou Admin do seu Grupo para te adicionar como **DME**, **Responsável** ou outro papel necessário.

**Posso usar o mesmo e-mail no Google e no cadastro local?**
Sim. O sistema unifica pelo e-mail. Se você se cadastrou primeiro com Google e tentar e-mail/senha depois (ou vice-versa), o login simplesmente reconhece a mesma conta.

**Como troco meu e-mail?**
Em **Meu perfil → Alterar e-mail**, informe o novo endereço. A troca só é efetivada quando você clica no link de confirmação enviado para o **novo** e-mail.

**Esqueci minha senha. Como recuperar?**
Use a opção do provedor (Google ou recuperação de senha do TAAEC). Se o problema persistir, contate o Admin Mestre.

---

## Sobre TAAECs

**Qual a diferença entre TAAEC "Ativa" e "Aprovada"?**
- **Aprovada** = total de TAAECs com decisão favorável, incluindo as já realizadas
- **Ativa** = aprovadas que ainda não aconteceram (estão no calendário futuro)

**Posso testar o wizard sem poluir o sistema?**
Sim. Na seção **1. Identificação da atividade** do wizard, ative o toggle **É um TAAEC de TESTE?**. Ela recebe código `TESTE-AAAA-XXXXXX`, não consome o contador oficial e pode ser excluída a qualquer momento. Ver [TAAECs](../modulos/taaecs.md#modo-teste).

**Quem pode editar uma TAAEC depois de submetida?**
- **Em construção**: só o Responsável
- **Em análise DME**: o Responsável pode editar se a DME devolver para correção
- **Aprovada**: edição é restrita; mudanças significativas exigem nova TAAEC
- **Admin Mestre**: pode editar qualquer TAAEC em qualquer estado (atos administrativos ficam no audit log)

**Por que minha TAAEC de risco BAIXO não foi para a Regional?**
A partir da versão 1.4.0, TAAECs com risco **reduzido** são encerradas automaticamente na etapa DME — não exigem parecer Regional. Isso desafoga a Regional para focar em atividades de risco moderado e elevado.

**O que é o carimbo digital SHA-256?**
É um hash criptográfico do conteúdo integral da TAAEC, gerado automaticamente. Garante integridade: se alguém alterasse qualquer campo, o hash mudaria. O carimbo é **versionado** — cada edição relevante gera nova versão com timestamp e hash novos.

---

## Sobre o motor de risco

**O motor diz risco moderado, mas eu acho que é alto — posso mudar?**
Não diretamente. O score é calculado pelo motor a partir dos fatores marcados (pernoite, distância do hospital, ramo, etc.). Se você acredita que faltou marcar algum fator, edite a TAAEC. Se a classificação não reflete o que você espera, registre observação no parecer da DME — a Regional considera contexto além do score.

**O que é o ICO?**
**Índice de Conformidade Operacional** — indicador 0–100 que mede a aderência da atividade às normas operacionais escoteiras (proporção adulto:jovem dentro do exigido, documentos anexados, primeiros socorros presentes, etc.). Quanto maior, mais conforme.

**Por que a proporção exigida muda?**
A proporção mínima depende de **dois eixos**: o ramo (Lobinho exige mais adultos que Pioneiro) e o risco (risco elevado exige mais adultos que risco reduzido). O motor aplica **sempre a proporção mais restritiva** entre os dois — para sua segurança.

**E se o motor exigir mais adultos do que tenho?**
Você tem três opções: (1) reduzir o número de jovens; (2) ajustar a atividade para um risco menor; (3) reforçar a equipe de chefia. O sistema bloqueia o envio à DME enquanto a proporção exigida não for atendida.

---

## Sobre fluxo multigrupo

**Meu grupo foi convidado para uma TAAEC. Como sei?**
Aparece em **Anuências** (no menu lateral, item específico). Você é o DME do grupo convidado e precisa lançar (a) jovens por ramo, (b) nº de chefes do seu grupo, (c) o PAXTU detalhado do seu grupo — **antes** que o Responsável envie a TAAEC para análise.

**E se eu não preencher a anuência?**
A TAAEC fica bloqueada na etapa do Responsável. Ele não consegue enviar à DME enquanto os grupos convidados não concluírem suas anuências. Você (e os outros DMEs) aparecem no card **Pendências de outros grupos convidados**.

---

## Sobre notificações

**Quem recebe e-mail e quando?**
- **DME** recebe quando uma nova TAAEC é criada no seu grupo
- **Admin Mestre** recebe quando uma nova sugestão é enviada
- **Telegram**: alertas críticos só vão para o chat do Admin Mestre (rejeitados se não autenticados pelo webhook secret)

**Não recebo nada. O que verificar?**
1. **Meu perfil**: e-mail correto e atualizado
2. **Caixa de spam**: notificações automáticas às vezes caem lá
3. **Admin Mestre**: verifica [Notificações → E-mail](../configuracoes/notificacoes.md#e-mail-institucional) → log de envio e reenvio manual

---

## Sobre segurança e auditoria

**O que é registrado no audit log?**
Toda criação, edição, aprovação, reprovação, atribuição de papel e operação sensível. Os registros são feitos por **trigger PostgreSQL** — não dependem do código de aplicação, então não é possível "burlar" o log mexendo no front-end.

**Outro grupo pode ver minhas TAAECs?**
Não. Os dados são isolados por **Row Level Security** no banco. Cada grupo só vê o que é seu. As exceções são: Regional e Admin Mestre (que veem tudo, por função), e grupos convidados (que veem a TAAEC multigrupo em que foram convidados).

**O sistema é seguro contra escalação de privilégio?**
Sim. Os papéis ficam em **tabela separada** da tabela de usuários — um usuário não consegue editar o próprio papel pelo perfil. Toda atribuição de papel passa por validação server-side e fica no audit log.

---

## Sobre o sistema

**Em qual stack o TAAEC roda?**
Frontend em **React + TypeScript**. Backend em **Supabase (PostgreSQL com Row Level Security)**. Autenticação por **Supabase Auth** (e-mail/senha + Google OAuth). Edge Functions para Telegram e e-mail SMTP. Hash SHA-256 do carimbo gerado via `crypto.subtle` no navegador.

**Onde fica o código-fonte?**
[github.com/ChefeBuzz/taaecregionaldf](https://github.com/ChefeBuzz/taaecregionaldf)

**Como sei a versão que estou usando?**
No bloco inferior do **Painel** aparece a versão (ex: `v1.4.0 · build 23/05/2026`), com lista das novidades da release atual e botão **Ver histórico completo**.

---

## Não achei minha dúvida aqui

Use o balão **💬 Sugestões / Correções** no canto inferior direito de qualquer tela. Sua mensagem vai direto para a administração, **já identificando a tela em que você estava e seu usuário** — não precisa explicar contexto.
