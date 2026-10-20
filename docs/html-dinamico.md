# Cards HTML dinâmicos

## Entrada → processamento → saída

**Entrada:** filtros do calendário, parâmetros, contatos e eventos. **Processamento:** DAX calcula volumes, contexto, comparação temporal e coordenadas dos gráficos. **Saída:** texto HTML/CSS/SVG renderizado no visual HTML Content.

O card de contatos identifica filtros por data, mês, trimestre e ano. A seleção por intervalo tem prioridade; para período personalizado compara com uma janela imediatamente anterior com igual duração. Os demais ramos usam PREVIOUSMONTH, PREVIOUSQUARTER e PREVIOUSYEAR. Não se deve interpretar todo comparativo como ano anterior.

A diferença absoluta e percentual controla seta, cor e texto. A curva SVG representa evolução dentro do contexto. O desenho responde às medidas e filtros; não é captura de gráfico.

## Código disponível

| Medida | Código |
| --- | --- |
| HTML Card - Contatos Únicos | [Abrir](../dax/html/01-html-card-contatos-unicos.dax) |
| HTML Tooltip - Comparativo | [Abrir](../dax/html/02-html-tooltip-comparativo.dax) |
| HTML Card - Conversões | [Abrir](../dax/html/03-html-card-conversoes.dax) |
| HTML Card - Levantada de Mão | [Abrir](../dax/html/04-html-card-levantada-de-mao.dax) |
| HTML Status Atualização | [Abrir](../dax/html/05-html-status-atualizacao.dax) |
| HTML Card - Download Material Rico | [Abrir](../dax/html/06-html-card-download-material-rico.dax) |
| HTML Card - Eventos | [Abrir](../dax/html/07-html-card-eventos.dax) |
| HTML Título - Leads Convertidos por Dia | [Abrir](../dax/html/08-html-titulo-leads-convertidos-por-dia.dax) |
| HTML Seletor Indicadores graf 1 | [Abrir](../dax/html/09-html-seletor-indicadores-graf-1.dax) |
| HTML Seletor Períodos | [Abrir](../dax/html/10-html-seletor-periodos.dax) |
| HTML Título - Últimas Conversões | [Abrir](../dax/html/11-html-titulo-ultimas-conversoes.dax) |
| HTML Seletor Indicadores graf 2 | [Abrir](../dax/html/12-html-seletor-indicadores-graf-2.dax) |
| HTML Título - Conversões Dinâmico | [Abrir](../dax/html/13-html-titulo-conversoes-dinamico.dax) |

## Pontos de adaptação

- As expressões dependem das tabelas e medidas de suporte; copiar somente HTML não cria um modelo funcional.
- Seletores HTML são apresentação do estado calculado. Uma medida DAX, por si só, não grava escolhas ou altera filtros; verificar a interação real do visual e dos segmentadores.
- Comparar seleções descontínuas e janelas parciais exige atenção: MIN/MAX e quantidade de dias descrevem uma janela contínua.
- DIVIDE com resultado alternativo zero pode exibir 0% quando a base anterior é zero; isso não significa ausência de mudança.
- Este material não foi renderizado ou executado no Power BI nesta preparação.
