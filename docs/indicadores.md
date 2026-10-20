# Indicadores e medidas

| Indicador | Definição encontrada |
| --- | --- |
| Quantidade de Contatos | DISTINCTCOUNT de RD_Contatos[uuid] |
| Quantidade de Conversões | COUNT de RD_Eventos_Contato[contact_uuid] |
| Quantidade de Leads convertidos | DISTINCTCOUNT do UUID nos eventos |
| Levantada de mão | UUID distinto nos eventos classificados como Levantada de Mão |
| Material Rico | UUID distinto na categoria Material Rico |
| Eventos | UUID distinto na categoria Eventos |
| Clientes | UUID distinto na categoria Clientes |
| Eventos não categorizados | Apesar do nome, a medida conta contatos distintos na categoria Outros |

Os cards de categorias contam contatos distintos, não necessariamente o total de eventos da categoria. Um mesmo contato pode integrar várias categorias; somar os cards pode superar o total de pessoas.

COUNT ignora UUIDs em branco, enquanto DISTINCTCOUNT pode incluir um valor em branco. A interpretação pressupõe qualidade das chaves. O +0 usado nas medidas transforma resultados em branco em zero.

## Exemplo real

```dax
Quantidade de Conversões = COUNT(RD_Eventos_Contato[contact_uuid]) + 0

Quantidade de Leads convertidos = DISTINCTCOUNT(RD_Eventos_Contato[contact_uuid]) + 0
```

O primeiro indicador mede linhas de evento com UUID; o segundo, pessoas identificadas nesses eventos.

As [medidas base](../dax/medidas-base.dax), [comparações](../dax/medidas-comparacao.dax) e [medidas dinâmicas](../dax/medidas-dinamicas.dax) estão disponíveis. Uma medida genérica de rascunho e uma declaração vazia foram excluídas da seleção pública.
