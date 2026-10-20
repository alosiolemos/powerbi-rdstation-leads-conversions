// Consulta original com servidor e banco substituídos por marcadores.
// Requer o esquema de dados e as funções/parâmetros descritos na documentação.
let
    Fonte = Sql.Database(
        "SERVIDOR_DEMO.database.windows.net",
        "BANCO_DEMO"
    ),
    Sql = "SELECT *
FROM Landing.VW_RD_Eventos_Contato_Classificados", 
    Resultado =
        Value.NativeQuery(
            Fonte,
            Sql
        ),
    Data_event_timestamp = Table.AddColumn(Resultado, "Data_event_timestamp", each DateTime.Date([event_timestamp]), type date),
    #"Função Personalizada Invocada" = Table.AddColumn(Data_event_timestamp, "Obter_Trafico", each fx_fnTraffic([payload_json], [traffic_source])),
    #"Obter_Trafico Expandido" = Table.ExpandRecordColumn(#"Função Personalizada Invocada", "Obter_Trafico", {"Evento", "Canal", "Origem", "Canal e Origem da Conversão", "Campanha", "CurrentSession", "FirstSession"}, {"Obter_Trafico.Evento", "Obter_Trafico.Canal", "Obter_Trafico.Origem", "Obter_Trafico.Canal e Origem da Conversão", "Obter_Trafico.Campanha", "Obter_Trafico.CurrentSession", "Obter_Trafico.FirstSession"})
in
    #"Obter_Trafico Expandido"
