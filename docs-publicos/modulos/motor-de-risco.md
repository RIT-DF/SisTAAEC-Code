# Motor de risco

O **motor de risco** é o núcleo inteligente do TAAEC. Avalia em tempo real, durante o preenchimento do wizard, o nível de risco da atividade proposta — gerando classificação, indicadores e recomendações.

Ele aparece como **painel lateral** no [wizard de criação](taaecs.md#criar-uma-nova-taaec) e como **bloco "Análise do risco"** na [tela de detalhe](taaecs.md#detalhe-de-uma-taaec) da TAAEC.

---

## O que o motor calcula

Três indicadores principais, exibidos lado a lado no painel:

| Indicador | O que mede | Onde aparece |
|---|---|---|
| **Score** | Pontuação numérica de risco (soma dos fatores) | Painel do wizard + detalhe da TAAEC |
| **Proporção** | `1 adulto : N jovens` realizada | Painel do wizard + detalhe da TAAEC |
| **ICO** | Índice de Conformidade Operacional (0–100%) | Painel do wizard + detalhe da TAAEC |

Mais a **classificação** (cor) e a **decisão** sugerida.

---

## Fatores de avaliação

O motor considera, entre outros:

- **Tipo de atividade e ambiente** (urbano, floresta, aquático, altitude)
- **Ramo escoteiro** e faixa etária dos participantes
- **Número de participantes** e proporção líder/escoteiro
- **Duração e distância** da atividade
- **Pernoite**
- **Condições logísticas**: hospital próximo, comunicação disponível, local vistoriado, primeiros socorros
- **Documentação**: PAXTU e Plano de Segurança anexados

Cada fator soma (ou abate) pontos no score. O detalhe — quanto cada fator pesou — fica visível na seção **Detalhamento do motor** do detalhe da TAAEC.

---

## Classificação de risco

| Classificação | Cor | ICO típico | Decisão padrão |
|---|---|---|---|
| **Baixo / Reduzido** | Verde | 80–100 | **Apto** — aprovação simplificada (encerra no DME) |
| **Moderado** | Amarelo | 50–79 | **Com ressalva** — recomendações obrigatórias, vai à Regional |
| **Alto / Elevado** | Vermelho | 0–49 | **Bloqueado** — revisão obrigatória antes de aprovação |

A classificação é exibida sempre como **tag colorida** ao lado do número.

---

## ICO — Índice de Conformidade Operacional

O **ICO** é um indicador numérico (0–100%) que mede o grau de conformidade da atividade com as normas operacionais escoteiras. Cobre fatores como:

- Proporção adulto:jovem dentro do mínimo exigido
- Anexação de PAXTU e Plano de Segurança
- Presença de primeiros socorros, comunicação e hospital próximo
- Vistoria do local

Quanto mais conforme, mais alto o ICO. **ICO ≥ 100%** indica que a atividade supera o mínimo exigido em todos os critérios.

---

## Proporção adulto:jovem

A proporção mínima de **adultos escotistas** depende de dois eixos:

### Por ramo

| Ramo | Proporção |
|---|---|
| Lobinho (6,5–10 anos) | 1 : 5 |
| Escoteiro (11–14 anos) | 1 : 7 |
| Sênior (15–17 anos) | 1 : 8 |
| Pioneiro (18–22 anos) | 1 : 10 |

### Por risco

| Risco | Proporção |
|---|---|
| Reduzido | 1 : 8 |
| Moderado | 1 : 6 |
| Elevado | 1 : 4 |

### Regra de combinação

O motor aplica **sempre a proporção mais restritiva** entre os dois eixos, e o **mínimo absoluto é sempre 2 adultos** — não importa quão pequena seja a atividade.

#### Exemplo prático

12 lobinhos em uma atividade de risco moderado:

- Pela tabela de ramo (Lobinho 1:5): exige `ceil(12/5) = 3` adultos
- Pela tabela de risco (moderado 1:6): exige `ceil(12/6) = 2` adultos
- **Exigência final**: 3 adultos (a mais restritiva)

---

## Tabelas detalhadas (mínimo de adultos por cenário)

As tabelas abaixo aparecem no rodapé do wizard como referência. Os números representam o **mínimo absoluto de adultos escotistas** exigido.

### Risco reduzido (proporção máxima 1:8)

| Ramo | 6 jovens | 12 jovens | 18 jovens | 24 jovens | 30 jovens | 36 jovens |
|---|---|---|---|---|---|---|
| Lobinho (6,5–10) | 2 | 3 | 4 | 5 | 6 | 8 |
| Escoteiro (11–14) | 2 | 2 | 3 | 4 | 5 | 6 |
| Sênior (15–17) | 2 | 2 | 3 | 3 | 4 | 5 |
| Pioneiro (18–22) | 2 | 2 | 3 | 3 | 4 | 5 |

### Risco moderado (proporção máxima 1:6)

| Ramo | 6 jovens | 12 jovens | 18 jovens | 24 jovens | 30 jovens | 36 jovens |
|---|---|---|---|---|---|---|
| Lobinho (6,5–10) | 2 | 3 | 4 | 5 | 6 | 8 |
| Escoteiro (11–14) | 2 | 2 | 3 | 4 | 5 | 6 |
| Sênior (15–17) | 2 | 2 | 3 | 4 | 5 | 6 |
| Pioneiro (18–22) | 2 | 2 | 3 | 4 | 5 | 6 |

### Risco elevado (proporção máxima 1:4)

| Ramo | 6 jovens | 12 jovens | 18 jovens | 24 jovens | 30 jovens | 36 jovens |
|---|---|---|---|---|---|---|
| Lobinho (6,5–10) | 2 | 3 | 5 | 6 | 8 | 9 |
| Escoteiro (11–14) | 2 | 3 | 5 | 6 | 8 | 9 |
| Sênior (15–17) | 2 | 3 | 5 | 6 | 8 | 9 |
| Pioneiro (18–22) | 2 | 3 | 5 | 6 | 8 | 9 |

!!! info "O motor recalcula ao vivo"
    Esses são pisos. O motor recalcula automaticamente conforme **fatores reais** marcados no wizard — pernoite, vistoria, comunicação, primeiros socorros, hospital próximo, etc. — e pode subir a exigência se o cenário concreto pedir.

---

## Regras críticas de override

Algumas condições **bloqueiam automaticamente** a aprovação, independentemente do score geral:

- Ausência de **plano de emergência** em atividades de alto risco
- Proporção líder/participante **abaixo do mínimo** para o ramo
- Atividade aquática **sem salva-vidas certificado**
- Ausência de **primeiro socorrista** em atividades fora de área urbana
- Documentação **PAXTU / Plano não anexada**

Quando uma regra crítica é acionada, o painel do motor exibe **aviso vermelho** e o botão **Enviar para DME** fica desabilitado até a condição ser resolvida.

---

## Reanalisar com o motor

No detalhe de uma TAAEC, o botão **Reanalisar com o motor** força o recálculo com a parametrização **atual** — útil quando o Admin Mestre / Regional alterou as tabelas em [Parametrização](../configuracoes/parametros.md) depois que a TAAEC foi gerada, e você quer revalidar.

A reanálise não altera o histórico da TAAEC; cria um novo ponto de avaliação que fica registrado.

---

## Onde ajustar as regras do motor

Apenas Admin Mestre e Regional acessam:

- **[Parametrização do motor](../configuracoes/parametros.md)** — tabelas de proporção, pesos dos fatores, regras de override
- **[Catálogo de atividades](../configuracoes/catalogo.md)** — atividades pré-definidas e seus riscos padrão

Mudanças nessas tabelas valem para TAAECs criadas **a partir do momento da alteração**. TAAECs antigas mantêm sua classificação original até alguém clicar em **Reanalisar com o motor**.
