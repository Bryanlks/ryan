USE [SEU_BANCO_DE_DADOS]; -- Substitua pelo nome do seu banco de dados, se necessário
GO

IF OBJECT_ID('dbo.sp_quadro_de_filas', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_quadro_de_filas;
GO

-- =================================================================
-- Autor: Ryan Torres
-- Data: Outubro / 2026
-- Descrição: Coleta dados estatísticos sobre a quantidade de pacientes 
--            aguardando atendimento nas UPAs de Porto Velho, 
--            agrupados por nível de risco (Protocolo de Manchester).
-- =================================================================
CREATE PROCEDURE dbo.sp_quadro_de_filas
    @UPA_id INT = NULL -- Parâmetro opcional: passe o ID para filtrar uma UPA específica ou NULL para todas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        u.nome AS Unidade_UPA,
        cr.cor AS Classificacao_Risco,
        COUNT(a.id) AS Total_Pacientes_Aguardando,
        ISNULL(MIN(DATEDIFF(MINUTE, a.hora_chegada, GETDATE())), 0) AS Menor_Tempo_Espera_Minutos,
        ISNULL(MAX(DATEDIFF(MINUTE, a.hora_chegada, GETDATE())), 0) AS Maior_Tempo_Espera_Minutos,
        ISNULL(AVG(DATEDIFF(MINUTE, a.hora_chegada, GETDATE())), 0) AS Tempo_Medio_Espera_Minutos
    FROM ATENDIMENTO a
    INNER JOIN UPA u 
        ON a.UPA_id = u.id
    INNER JOIN CLASSIFICACAO_RISCO cr 
        ON a.classificacao_risco_id = cr.id
    WHERE a.status = 'AGUARDANDO'
      AND (@UPA_id IS NULL OR a.UPA_id = @UPA_id)
    GROUP BY 
        u.nome, 
        cr.cor, 
        cr.id
    ORDER BY 
        u.nome ASC,
        cr.id ASC;
END;
GO
