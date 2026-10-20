// Consulta original com servidor e banco substituídos por marcadores.
// Requer o esquema de dados e as funções/parâmetros descritos na documentação.
let
    Fonte = Sql.Database(
        "SERVIDOR_DEMO.database.windows.net",
        "BANCO_DEMO"
    ),
    Sql = "SELECT 
    *
FROM Landing.RD_Contacts rc",       

    Resultado =
        Value.NativeQuery(
            Fonte,
            Sql,
            [RangeStart = RangeStart, RangeEnd = RangeEnd]
        ),
    #"Data de criação do lead" = Table.AddColumn(Resultado, "Data de criação do lead", each DateTime.Date([created_at]), type date),
    #"Data última covnersão" = Table.AddColumn(#"Data de criação do lead", "Data última covnersão", each DateTime.Date([last_conversion_date]), type date)
in
    #"Data última covnersão"
