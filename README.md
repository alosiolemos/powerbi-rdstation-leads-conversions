# RD Station Analytics — Power BI, HTML Dinâmico, n8n e Azure SQL

Painel de leads e conversões que combina **cards HTML/CSS gerados por DAX**, histórico de eventos, classificação de tráfego e uma engenharia de dados orientada a conversões do RD Station.

## O desafio

Antes do painel, a preparação do relatório exigia quase um dia de trabalho manual para reunir registros, cruzar informações e excluir testes. Desenvolvi a solução para centralizar contatos e conversões, permitindo consultas em poucos segundos, com filtros interativos e dados atualizados por uma automação.

Na minha operação, observei cerca de 60 segundos para atualização/consulta, dependendo dos filtros. Esse tempo não foi medido de forma independente nesta publicação e não representa um SLA ou uma garantia para outros ambientes.

## O diferencial: cards que respondem ao contexto

Os cards não são imagens estáticas. As medidas calculam o valor do indicador, detectam o contexto de período, escolhem o comparativo, ajustam cores e setas e geram HTML/CSS com pequenas curvas em SVG. Títulos, textos de apoio e status também são produzidos dinamicamente.

- Contatos únicos e total de conversões.
- Contatos que solicitaram atendimento comercial — levantada de mão.
- Downloads de materiais, eventos e classificação de clientes.
- Canais de conversão, origem atribuída ao contato e últimas conversões.
- Seleção de métrica e granularidade temporal.

O relatório combina HTML Content com gráficos, tabela e segmentadores nativos. Não é integralmente HTML.

## Integração verificada

```mermaid
flowchart LR
    A[RD Station: webhook de conversão] --> B[n8n: normalização de contatos e eventos]
    B --> C[Azure SQL: MERGE e chaves de evento]
    C --> D[n8n: sincronização dos ramos e espera]
    D --> E[Autenticação Microsoft e solicitação de refresh]
    E --> F[Modelo Power BI em Importação]
    C --> F
    F --> G[DAX e HTML/CSS/SVG dinâmicos]
```

O workflow recebido contém chamada de atualização pela API do Power BI. O modelo usa **Importação**, portanto atualizar o Azure é uma etapa diferente de atualizar o dataset. A solicitação de refresh não comprova conclusão nem elimina limites de capacidade/licenciamento.

## Screenshots

![Painel de leads e conversões com cards HTML dinâmicos](assets/screenshots/PBI%20MARKETING%20-%20HTML.png)


## Explore

- [Contexto, entregas e impacto](docs/contexto.md)
- [Cards HTML e comparativos](docs/html-dinamico.md)
- [Modelo e relacionamentos coluna a coluna](docs/modelo-relacionamentos.md)
- [Indicadores e interpretação](docs/indicadores.md)
- [Fluxo de dados e atualização](docs/integracao-atualizacao.md)
- [Normalização de tráfego e origem](docs/tratamento-atribuicao.md)
- [Inventário técnico](docs/inventario.md)
- [Como adaptar](docs/configuracao.md)
- [Validação e limites](docs/validacao.md)
- [Medidas HTML completas](dax/html)
- [Power Query](power-query)

## Escopo público

Publicação seletiva para portfólio: medidas HTML, medidas de suporte, consultas com marcadores e documentação. Não inclui PBIX/PBIP completo, dados de contatos, payloads reais, credenciais, IDs de tenant/workspace/dataset ou conexões operacionais. A automação complementar está documentada em [n8n — RD Station, Azure SQL e Power BI](https://github.com/alosiolemos/n8n-rdstation-azure-powerbi-sync), com template inativo, código de tratamento e testes locais.
