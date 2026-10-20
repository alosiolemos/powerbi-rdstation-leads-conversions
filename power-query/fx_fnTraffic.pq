// Função extraída do modelo. Recebe payload JSON e origem opcional do banco.
(payload_json as nullable text, optional traffic_source_banco as nullable text) as record =>

let
    Payload =
        try Json.Document(payload_json)
        otherwise null,

    MediumRaw =
        try Text.From(Payload[traffic_medium])
        otherwise null,

    SourcePayload =
        try Text.From(Payload[traffic_source])
        otherwise null,

    CampaignRaw =
        try Text.From(Payload[traffic_campaign])
        otherwise null,

    ConversionIdentifier =
        try Text.From(Payload[conversion_identifier])
        otherwise null,

    // Prioriza a coluna traffic_source gravada no banco
    SourceRaw =
        if traffic_source_banco <> null
            and Text.Trim(Text.From(traffic_source_banco)) <> ""
        then Text.From(traffic_source_banco)
        else SourcePayload,

    // ============================================================
    // 1. VERIFICA SOURCE ENCODED
    // ============================================================

    IsEncoded =
        SourceRaw <> null
        and Text.StartsWith(
            Text.Lower(SourceRaw),
            "encoded_"
        ),

   Base64Raw =
    if IsEncoded then
        Text.Range(
            SourceRaw,
            Text.Length("encoded_")
        )
    else
        null,

    Base64Length =
        if Base64Raw <> null then
            Text.Length(Base64Raw)
        else
            0,

    Base64Resto =
        Number.Mod(Base64Length, 4),

    Base64 =
        if Base64Raw = null then
            null
        else if Base64Resto = 2 then
            Base64Raw & "=="
        else if Base64Resto = 3 then
            Base64Raw & "="
        else
            Base64Raw,

    DecodedText =
        if Base64 <> null then
            try
                Text.FromBinary(
                    Binary.FromText(
                        Base64,
                        BinaryEncoding.Base64
                    ),
                    TextEncoding.Utf8
                )
            otherwise null
        else
            null,

    DecodedJson =
        if DecodedText <> null then
            try Json.Document(DecodedText)
            otherwise null
        else
            null,

    CurrentSession =
        try Text.From(
            DecodedJson[current_session][value]
        )
        otherwise null,

    FirstSession =
        try Text.From(
            DecodedJson[first_session][value]
        )
        otherwise null,


    // ============================================================
    // 2. SOURCE NORMAL COM UTM
    // Ex:
    // utm_source=LinkedIn%20Ads&utm_medium=cpc
    // ============================================================

    SourceTemUTM =
        SourceRaw <> null
        and (
            Text.Contains(
                Text.Lower(SourceRaw),
                "utm_source="
            )
            or
            Text.Contains(
                Text.Lower(SourceRaw),
                "utm_medium="
            )
            or
            Text.Contains(
                Text.Lower(SourceRaw),
                "utm_campaign="
            )
        )
        and not IsEncoded,

    SourceParams =
        if SourceTemUTM then
            try
                Uri.Parts(
                    "https://example.com" & SourceRaw
                )[Query]
            otherwise null
        else
            null,

    SourceUTM =
        try Text.From(SourceParams[utm_source])
        otherwise null,

    MediumUTM =
        try Text.From(SourceParams[utm_medium])
        otherwise null,

    CampaignUTM =
        try Text.From(SourceParams[utm_campaign])
        otherwise null,


    // ============================================================
    // 3. CURRENT SESSION DO ENCODED
    // ============================================================

    SessionParaUTM =
    if CurrentSession <> null
        and Text.Trim(CurrentSession) <> ""
        and CurrentSession <> "(none)"
    then CurrentSession

    else if FirstSession <> null
        and Text.Trim(FirstSession) <> ""
        and FirstSession <> "(none)"
    then FirstSession

    else null,

    CurrentParams =
        if SessionParaUTM <> null
            and not Text.StartsWith(
                Text.Lower(SessionParaUTM),
                "http"
            )
        then
            try
                Uri.Parts(
                    "https://example.com" & SessionParaUTM
                )[Query]
            otherwise null
        else
            null,

    MediumCurrent =
        try Text.From(CurrentParams[utm_medium])
        otherwise null,

    SourceCurrent =
        try Text.From(CurrentParams[utm_source])
        otherwise null,

    CampaignCurrent =
        try Text.From(CurrentParams[utm_campaign])
        otherwise null,


    // ============================================================
    // 4. CAMPOS FINAIS
    // ============================================================

    MediumFinal =
        if MediumRaw <> null
            and MediumRaw <> ""
        then MediumRaw

        else if MediumUTM <> null
        then MediumUTM

        else MediumCurrent,

    SourceFinal =
        if SourceUTM <> null
            and SourceUTM <> ""
        then SourceUTM

        else if IsEncoded then
            SourceCurrent

        else
            SourceRaw,

    CampaignFinal =
        if CampaignRaw <> null
            and CampaignRaw <> ""
        then CampaignRaw

        else if CampaignUTM <> null
        then CampaignUTM

        else CampaignCurrent,


    // ============================================================
    // 5. FALLBACK POR SESSÃO / URL
    // ============================================================

    SessionFallback =
        if CurrentSession <> null
            and CurrentSession <> ""
            and CurrentSession <> "(none)"
        then CurrentSession
        else FirstSession,

    SessionEhURL =
        SessionFallback <> null
        and (
            Text.StartsWith(
                Text.Lower(SessionFallback),
                "https://example.com"
            )
            or
            Text.StartsWith(
                Text.Lower(SessionFallback),
                "https://example.com"
            )
        ),

    DominioFallback =
        if SessionEhURL then
            try Uri.Parts(SessionFallback)[Host]
            otherwise null
        else
            null,


    // ============================================================
    // 6. TEXTO PARA CLASSIFICAÇÃO
    // ============================================================

    TextoCanal =
        Text.Lower(
            Text.Combine(
                List.RemoveNulls({
                    MediumFinal,
                    SourceFinal
                }),
                "|"
            )
        ),


        // ============================================================
    // 7. CANAL
    // ============================================================

    EhPago =
        Text.Contains(TextoCanal, "cpc")
        or Text.Contains(TextoCanal, "ppc")
        or Text.Contains(TextoCanal, "paid")
        or Text.Contains(TextoCanal, "paid_social")
        or Text.Contains(TextoCanal, "paidsocial"),

    EhSocial =
        Text.Contains(TextoCanal, "linkedin")
        or Text.Contains(TextoCanal, "instagram")
        or Text.Contains(TextoCanal, "facebook")
        or Text.Contains(TextoCanal, "tiktok")
        or Text.Contains(TextoCanal, "youtube")
        or Text.Contains(TextoCanal, "social")
        or Text.Lower(Text.From(SourceFinal ?? "")) = "ig"
        or Text.Lower(Text.From(SourceFinal ?? "")) = "fb",

    EhEmail =
        Text.Contains(TextoCanal, "email")
        or Text.Contains(TextoCanal, "e-mail"),

    EhOrganico =
        Text.Contains(TextoCanal, "organic")
        or Text.Contains(TextoCanal, "organico")
        or Text.Contains(TextoCanal, "orgânico"),

    EhReferencia =
        Text.Contains(TextoCanal, "referral"),

    Canal =
        // --------------------------------------------------------
        // SOCIAL PAGO
        // Ex.: linkedin + cpc / instagram + paid
        // --------------------------------------------------------
        if EhSocial and EhPago
        then "Social Pago"

        // --------------------------------------------------------
        // SOCIAL ORGÂNICO
        // --------------------------------------------------------
        else if EhSocial and not EhPago
        then "Social Orgânico"

        // --------------------------------------------------------
        // TRÁFEGO PAGO
        // Ex.: Google Ads / Bing Ads
        // --------------------------------------------------------
        else if EhPago
        then "Tráfego Pago"

        // --------------------------------------------------------
        // EMAIL
        // --------------------------------------------------------
        else if EhEmail
        then "Email"

        // --------------------------------------------------------
        // TRÁFEGO ORGÂNICO
        // --------------------------------------------------------
        else if EhOrganico
        then "Tráfego Orgânico"

        // --------------------------------------------------------
        // REFERÊNCIA
        // --------------------------------------------------------
        else if EhReferencia
        then "Referência"

        // --------------------------------------------------------
        // DIRETO INFORMADO PELO RD
        // --------------------------------------------------------
        else if IsEncoded
            and CurrentSession = "(none)"
        then "Tráfego Direto"

        // --------------------------------------------------------
        // URL DE REDE SOCIAL
        // --------------------------------------------------------
        else if SessionEhURL
            and DominioFallback <> null
            and (
                Text.Contains(Text.Lower(DominioFallback), "linkedin")
                or Text.Contains(Text.Lower(DominioFallback), "instagram")
                or Text.Contains(Text.Lower(DominioFallback), "facebook")
                or Text.Contains(Text.Lower(DominioFallback), "tiktok")
                or Text.Contains(Text.Lower(DominioFallback), "youtube")
            )
        then "Social Orgânico"

        // --------------------------------------------------------
        // URL SEM OUTRA IDENTIFICAÇÃO
        // --------------------------------------------------------
        else if SessionEhURL
        then "Tráfego Direto"

        // --------------------------------------------------------
        // SEM INFORMAÇÃO
        // --------------------------------------------------------
        else if TextoCanal = ""
        then "Desconhecido"

        else "Outros",
        
    // ============================================================
    // 8. ORIGEM FINAL
    // ============================================================

    OrigemFinal =
        if SourceFinal <> null
            and SourceFinal <> ""
            and not SourceTemUTM
        then SourceFinal

        else if SessionEhURL
            and DominioFallback <> null
            and Text.Contains(
                Text.Lower(DominioFallback),
                "linkedin"
            )
        then "LinkedIn"

        else if SessionEhURL
            and DominioFallback <> null
            and Text.Contains(
                Text.Lower(DominioFallback),
                "instagram"
            )
        then "Instagram"

        else if SessionEhURL
            and DominioFallback <> null
            and Text.Contains(
                Text.Lower(DominioFallback),
                "facebook"
            )
        then "Facebook"

        else if SessionEhURL
        then DominioFallback

        else SourceUTM,
    // ============================================================
    // 9. CANAL + ORIGEM DA CONVERSÃO
    // Ex.: Tráfego Pago | google
    //      Social Pago | meta
    // ============================================================

    CanalOrigemConversao =
        if Canal <> null
            and Text.Trim(Text.From(Canal)) <> ""
            and OrigemFinal <> null
            and Text.Trim(Text.From(OrigemFinal)) <> ""
        then
            Canal & " | " & OrigemFinal

        else if Canal <> null
            and Text.Trim(Text.From(Canal)) <> ""
        then
            Canal

        else if OrigemFinal <> null
            and Text.Trim(Text.From(OrigemFinal)) <> ""
        then
            OrigemFinal

        else
            "Desconhecido",

    Resultado = [
        Evento = ConversionIdentifier,
        Canal = Canal,
        Origem = OrigemFinal,
        #"Canal e Origem da Conversão" = CanalOrigemConversao,
        Campanha = CampaignFinal,
        CurrentSession = CurrentSession,
        FirstSession = FirstSession
    ]
    

in
    Resultado
