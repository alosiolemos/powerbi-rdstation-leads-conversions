# Contexto, entregas e impacto

O projeto acompanha a jornada de conversões do RD Station, mantendo visão de contatos e eventos. Um contato pode converter várias vezes, exigindo separar quantidade de pessoas e quantidade de conversões.

Identifiquei que a preparação manual consumia quase um dia para cruzar informações, identificar testes e montar o relatório. Com a solução que desenvolvi, a análise passou a ser acessada em poucos segundos. Esses tempos refletem minha experiência operacional, sem cronometragem ou comparação controlada nesta publicação.

## Entregas

- Histórico analítico de conversões no Azure SQL.
- Recepção de eventos por webhook e tratamento no n8n.
- Atualização do dataset solicitada pela API Microsoft Power BI.
- Cards HTML dinâmicos, títulos, comparativos, status e seletores.
- Indicadores por categoria, canal, origem e período.
- Histórico das últimas conversões.

O código recebido processa a última conversão de cada lead presente no webhook e persiste eventos ao longo do tempo. Isso não comprova recuperação de todo o histórico anterior à ativação: backfill ou carga histórica adicional não foi identificado nesta automação.
