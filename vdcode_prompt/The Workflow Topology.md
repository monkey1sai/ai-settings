graph TD
    %% 階段定義
    subgraph S1_定義階段 [Stage 1: 產品與架構定義]
        CEO(CEO/User) -->|原始需求| PM[AI 產品工程師]
        PM -->|PRD & Roadmap| ARCH[架構滅絕師]
        PM -->|成本/資源限制| INFRA_P[AI 基礎設施]
        ARCH -->|架構藍圖 & 邊界劃分| KICKOFF((Kick-off))
    end

    subgraph S2_地基階段 [Stage 2: 數據與環境準備]
        KICKOFF --> DATA[AI 資料工程師]
        KICKOFF --> INFRA[AI 基礎設施]
        DATA -->|清洗後數據 & 向量庫| AGENT
        DATA -->|黃金測試集 Golden Dataset| EVAL
        INFRA -->|CI/CD & Dev 環境| DEV_ENV((開發環境就緒))
    end

    subgraph S3_核心開發 [Stage 3: 雙軌並行開發]
        DEV_ENV --> AGENT[AI Agent 工程師]
        DEV_ENV --> FULL[Google 全端工程師]
        
        AGENT -->|Agent Graph & Tool Schema| FULL
        FULL -->|API & Frontend| INTEGRATION((系統整合))
    end

    subgraph S4_驗收與優化 [Stage 4: 品質閘門]
        INTEGRATION --> EVAL[AI 資料工程師: RAG評測]
        INTEGRATION --> CODE_REV[架構滅絕師: Code Review]
        
        EVAL --未達標--> AGENT
        CODE_REV --有異味--> FULL
        CODE_REV --有異味--> AGENT
    end

    subgraph S5_部署與運維 [Stage 5: 生產環境]
        EVAL & CODE_REV -->|Pass| DEPLOY[AI 基礎設施: 部署]
        DEPLOY --> OBSERVE[監控與日誌]
        OBSERVE -->|反饋迴圈| PM
    end
