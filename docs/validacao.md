# Validação e limites

## Verificado estaticamente

Leitura dos arquivos TMDL, quatro relacionamentos, modo Importação, expressões DAX/HTML e consultas Power Query. Inventário dos JSONs de páginas e visuais. Inspeção dos nós da automação para confirmar SQL, chaves de evento e chamada de refresh.

O export n8n contém um valor inválido em pinData, impedindo parse integral como JSON. Para análise, o bloco nodes foi lido separadamente, sem usar dados fixados. O arquivo original não foi alterado; a correção do template ficará para o case n8n.

## Preparação pública

Servidor e banco substituídos por marcadores; marcas específicas generalizadas no código publicado. Somente expressões e consultas selecionadas foram exportadas. Não foram copiados payloads, dados de contato, credenciais, URLs operacionais, IDs de ambiente ou o relatório completo.

O modelo de origem contém credenciais literais em uma função auxiliar de API. Essa função não foi publicada. A distribuição pública não deve ser usada para recuperar ou manter credenciais do ambiente.

## Não executado

Não houve chamadas às APIs, consultas ao banco, atualização de dataset, importação no Power BI ou renderização dos cards. A leitura estática não confirma desempenho, resultado DAX em todos os contextos, integridade do banco ou funcionamento em produção.

A publicação documenta a implementação recebida; não assegura tempo real, ausência de limites de refresh ou disponibilidade permanente.
