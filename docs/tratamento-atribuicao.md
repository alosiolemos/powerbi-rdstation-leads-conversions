# Tratamento e atribuição de tráfego

## Power Query

As consultas usam Sql.Database e Value.NativeQuery para ler contatos e uma view de eventos classificados. O modelo transforma timestamps em datas e aplica **fx_fnTraffic** ao payload JSON do evento, com origem opcional do banco como apoio.

A função retorna Evento, Canal, Origem, Campanha, CurrentSession, FirstSession e Canal e Origem da Conversão. O código trata payload ausente/inválido com try/otherwise e combina evidências de campos de tráfego, UTM e sessões/URLs. Na ausência de identificação suficiente, pode retornar Desconhecido ou Outros.

- [Função de tráfego](../power-query/fx_fnTraffic.pq)
- [Consulta de contatos com marcadores](../power-query/RD_Contatos.pq)
- [Consulta de eventos com marcadores](../power-query/RD_Eventos_Contato.pq)

A classificação comercial de evento é recebida de uma view SQL. Sua definição não foi fornecida, portanto não se publica uma regra inventada para levantada de mão, materiais ou eventos.

## Origem do contato e origem da conversão

A coluna calculada [Origem do Lead](../dax/origem-do-lead.dax) procura eventos do UUID e usa TOPN pela **data** do evento, em ordem decrescente. Assim, o nome não significa necessariamente primeira aquisição: o código utiliza o registro mais recente segundo a data considerada.

Como o critério é uma data sem horário, eventos do mesmo dia podem empatar. TOPN pode retornar múltiplas linhas e MAXX seleciona um canal; não se deve apresentar isso como desempate cronológico preciso. Esta particularidade foi preservada na expressão publicada.

## Parâmetros de intervalo

RangeStart e RangeEnd aparecem no modelo e como parâmetros enviados na consulta de contatos. A SQL recebida não contém predicado temporal usando esses parâmetros, e a consulta de eventos também não aplica esse filtro. Portanto sua presença não comprova atualização incremental ou leitura limitada ao intervalo.
