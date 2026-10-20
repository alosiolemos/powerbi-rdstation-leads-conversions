# Integração e atualização

## Caminho identificado na automação

1. Webhook recebe leads do RD Station.
2. Um ramo normaliza contatos; outro normaliza a última conversão recebida por lead.
3. Geradores de SQL transformam lotes em JSON lido por OPENJSON.
4. MERGE atualiza ou insere contatos por UUID e eventos por chave de evento.
5. Os ramos passam por Merge e Wait.
6. O fluxo obtém token Microsoft e faz uma requisição ao endpoint de refresh do Power BI.

Foram identificados 16 nós no arquivo recebido, incluindo quatro Code, dois Microsoft SQL, dois HTTP Request e um webhook. O workflow completo não é distribuído neste repositório.

## Histórico e duplicidade

Nos contatos, ROW_NUMBER particiona por UUID e ordena pela última conversão para selecionar uma linha por lote. No ramo de eventos, um Set elimina chaves repetidas na execução. A chave concatena UUID, tipo, identificador e timestamp; o SQL calcula SHA2_256 e usa o resultado no MERGE.

Isso demonstra intenção de reprocessamento sem inserir novamente o mesmo evento segundo essa chave. Não comprova garantia global contra duplicação: índices únicos, concorrência, transações, precisão e padronização de timestamps precisam ser verificados no banco. Um evento equivalente com timestamp textual diferente pode produzir outra chave.

## O que significa atualizar

As partições RD_Contatos e RD_Eventos_Contato usam **mode: import**. Uma conversão no SQL não aparece no cache importado antes de concluir a atualização do modelo. Solicitar refresh por API é assíncrono; uma resposta de aceite não significa conclusão, nem força atualização de uma página já aberta.

Não foi identificado acompanhamento de status do refresh no fluxo recebido. Também não há evidência de Power BI Embedded ou DirectQuery nesta exportação. A integração confirmada é a solicitação de refresh pela API Power BI.

O comportamento por evento depende de capacidade, limites do serviço, autenticação e concorrência. Não se afirma que a automação elimina limites de atualização ou opera indefinidamente sem manutenção. Os cerca de 60 segundos descritos pelo autor são observação operacional, não garantia.

## Possíveis evoluções

Agrupar eventos em janelas, evitar refresh concorrente, acompanhar status e falhas, monitorar autenticação e controlar reprocessamento. Essas sugestões não representam funcionalidades já implementadas.
