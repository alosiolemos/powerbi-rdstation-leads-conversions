# Como adaptar o material

1. Trabalhe em um modelo de demonstração com contatos e eventos fictícios.
2. Configure servidor e banco nas consultas por um mecanismo privado e credenciais do conector SQL.
3. Disponibilize as tabelas/views e colunas esperadas. O DDL e a view de classificação não acompanham esta publicação.
4. Crie o calendário e os parâmetros conforme a estrutura documentada.
5. Reproduza e valide os quatro relacionamentos descritos.
6. Adicione as medidas base, comparação e dinâmicas antes das medidas HTML.
7. Renderize as medidas HTML no visual compatível e confira filtros e comparativos.

As consultas não são um pacote executável independente. RD_Contatos referencia RangeStart/RangeEnd; defina parâmetros DateTime se usar essa consulta. Esses parâmetros não filtram a SQL fornecida.

## Testes sugeridos no Power BI

- Um contato com três conversões deve resultar em três eventos e uma pessoa no contexto adequado.
- Filtrar uma categoria deve manter a semântica de pessoas distintas daquela categoria.
- Verificar meses sem dados e base anterior zero nos cards.
- Comparar a mesma janela e conferir a legenda do período de comparação.
- Após nova conversão, separar persistência SQL, conclusão do refresh e atualização do visual.

Esses testes são orientações; não foram executados nesta preparação.
