# Sistema UPA Monitor de Porto Velho — Modelagem e Consultas SQL

Repositório dedicado à atividade acadêmica que engloba a modelagem de dados conceitual (Diagrama ER em Mermaid) e a implementação de procedures estatísticas para o sistema **UPA Monitor de Porto Velho**.

---

## 📋 Questão 1: Modelagem de Dados (MERMAID)

O diagrama abaixo representa o fluxo de pacientes, unidades, setores e classificações de risco das UPAs.

```mermaid
erDiagram
    UPA ||--o{ SETOR : "possui"
    UPA ||--o{ ATENDIMENTO : "realiza"
    PACIENTE ||--o{ ATENDIMENTO : "possui"
    CLASSIFICACAO_RISCO ||--o{ ATENDIMENTO : "classifica"

    UPA {
        int id PK
        string nome
        string endereco
    }

    SETOR {
        int id PK
        int UPA_id FK
        string nome
    }

    CLASSIFICACAO_RISCO {
        int id PK
        string cor
        string descricao
    }

    PACIENTE {
        int id PK
        string nome
        string cartao_sus
        date data_nascimento
    }

    ATENDIMENTO {
        int id PK
        int paciente_id FK
        int UPA_id FK
        int classificacao_risco_id FK
        time hora_chegada
        time hora_atendimento
        string status
    }
\`\`\`

---

## ⚙️ Questão 2: O Desafio do "Prompt Inverso" (Stored Procedures)

### 1. Log da Conversa com a IA e Correções
* **Prompt Inicial:** Solicitação de criação das procedures `sp_quadro_de_filas` e `sp_atlas_e_cubos`.
* **Erros Identificados na Resposta da IA:** A IA inicialmente alucinou tabelas inexistentes no contexto de uma UPA (como leitos de UTI e tabelas de internação prolongada).
* **Correções Aplicadas:** Ajustamos o escopo para focar estritamente no fluxo ambulatorial de urgência e emergência, filas por classificação de risco (Protocolo de Manchester) e cálculo de tempo de espera em minutos através de `DATEDIFF`.

### 2. Scripts SQL Implementados
Os códigos completos encontram-se na pasta \`/sql\` deste repositório ou podem ser consultados diretamente abaixo:

- **sp_quadro_de_filas:** Coleta dados estatísticos de pacientes aguardando atendimento por cor de risco.
- **sp_atlas_e_cubos:** Coleta métricas de desempenho e volume de atendimentos por unidade e setor.
