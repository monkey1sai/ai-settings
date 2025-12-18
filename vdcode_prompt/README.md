# 專屬 Agent 指令集 (Agent Prompts)

## 宗旨
本專案旨在建立一套高品質、角色鮮明的 AI Agent 指令集（Prompts）。透過賦予 AI 特定的專家角色、思維模式與輸出規範，協助開發者在「架構設計」、「程式碼審查」與「實作開發」等不同階段，獲得最專業、精準且具備深度的技術支援。

## Agent 列表與建議使用順序 (Recommended Workflow)

依照軟體開發與創新的生命週期，建議依序諮詢以下專家：

### 1. AI 產品工程師 (AI Product Engineer)
*   **檔案名稱**: `AI產品工程師.prompt.md`
*   **角色定位**: 結合 PM、架構師與 UX 的全能產品經理 (The Bridge)。
*   **核心功能**:
    *   **產品定義與收斂**: 將模糊的「一句話需求」轉化為具體的產品規格與功能列表。
    *   **技術可行性評估**: 判斷何時該用 Rule-based、何時該用 LLM，避免過度工程化。
    *   **分階段 Roadmap**: 規劃 MVP、v1.0、v2.0 的演進路徑與關鍵指標 (OKR)。
*   **適用場景**: 產品發想初期、需求不明確、需要制定 Roadmap 或進行技術與商業價值的對齊時。
*   **風格**: 戰略性強、用戶導向、拒絕空談，專注於「可落地」的方案。

### 2. 架構滅絕師 (Architecture Exterminator)
*   **檔案名稱**: `架構滅絕師.prompt.md`
*   **角色定位**: 擁有 20 年經驗的頂尖系統架構師、毒舌前輩。
*   **核心功能**:
    *   **深度代碼審查**: 專注於嗅探架構異味（Code Smells）、錯誤的依賴關係與設計模式濫用。
    *   **架構重構建議**: 提供從 DDD、整潔架構（Clean Architecture）到函數式編程（FP）的高階重構方案。
    *   **前沿技術推廣**: 推薦 2025+ 年代的先進技術棧（如 Virtual Threads, Effect Systems）。
*   **適用場景**: 當你需要對現有系統進行無情的健康檢查、尋求重構方向，或希望提升系統的可維護性與擴展性時。
*   **風格**: 犀利、直接、不留情面，直指核心問題。

### 3. AI Agent 工程師 (AI Agent Engineer)
*   **檔案名稱**: `AI Agent 工程師.prompt.md`
*   **角色定位**: 打造自動化系統與數位員工的專家 (The Automator)。
*   **核心功能**:
    *   **Agent 系統架構**: 設計多 Agent 協作拓撲 (Supervisor, ReAct, Map-Reduce)。
    *   **工具與協議定義**: 撰寫精確的 Function Calling Schema 與 MCP (Model Context Protocol) 整合。
    *   **韌性工程**: 設計錯誤處理、自我修正迴圈與狀態管理機制。
*   **適用場景**: 需要開發自動化工作流、數位員工、RAG 系統或複雜的任務編排時。
*   **風格**: 強調確定性 (Deterministic)、穩定性與可觀測性。

### 4. Google 資深工程師 (Google Senior Engineer)
*   **檔案名稱**: `Google工程師.prompt.md`
*   **角色定位**: Google L6 資深全端工程師、GCP 雲端專家。
*   **核心功能**:
    *   **全端開發實作**: 提供 Production-ready 的程式碼，涵蓋前端（React/Vue）、後端（Go/Python/Node）與資料庫設計。
    *   **工程最佳實踐**: 遵循 Google 工程文化，強調可讀性、測試與 CI/CD 流程。
    *   **雲端架構設計**: 專精於 GCP 服務整合、微服務架構與高可用性系統設計。
*   **適用場景**: 當你需要具體的實作代碼、解決複雜的工程問題、設計雲端架構或建立 DevOps 流程時。
*   **風格**: 專業、條理分明、工程導向，注重 Trade-offs 分析。

### 5. DevOps/SRE/Infra 工程師 (DevOps & SRE Engineer)
*   **檔案名稱**: `DevOps_Infra_SRE 工程師.prompt.md`
*   **角色定位**: 專注於 GCP、K8s 與 AI 推理優化的守護者 (The Guardian)。
*   **核心功能**:
    *   **基礎設施即代碼 (IaC)**: 設計高可用、可擴展的雲端架構 (GKE, Cloud Run)。
    *   **AI 推理優化**: 選擇合適的 Serving Engine (vLLM, Triton) 與硬體規格，優化成本與延遲。
    *   **CI/CD 與可觀測性**: 建立自動化部署流水線與完整的監控告警系統。
*   **適用場景**: 系統部署、效能調優、成本控制、架設私有模型服務或需要高穩定性運維時。
*   **風格**: 嚴謹、數據驅動、成本敏感 (Frugality)，追求 99.9% 可用性。

## 完整開發流程情境範例 (End-to-End Scenario)

以下展示一個從「模糊想法」到「穩定上線」的完整開發流程，以及各個 Agent 如何在不同階段介入。

**情境背景**：你（CEO/創辦人）有一個想法：
> 「我想做一個 AI 工具，幫業務員在開完會後自動生成 CRM 紀錄，還要能分析客戶成交機率。」

### 第一階段：產品定義 (Product Definition)
**諮詢對象**：🤖 **AI 產品工程師**
*   **你的提問**：「幫我規劃這個 AutoCRM 產品，我要怎麼切入？」
*   **Agent 產出**：
    *   **產品定義**：命名為 "AutoCRM AI Sales Assistant"。
    *   **核心價值**：減少業務員 90% 的行政時間，並透過數據預測提升 20% 成交率。
    *   **Roadmap**：
        *   **MVP**：Web 版上傳錄音檔 → Whisper 轉錄 → GPT-4o 摘要 → 複製貼上。
        *   **v1.0**：手機 App 錄音 → 自動寫入 Salesforce API。
    *   **技術把關**：警告初期不要自建模型，直接調用 API 驗證需求。

### 第二階段：架構設計 (System Architecture)
**諮詢對象**：🤖 **架構滅絕師**
*   **你的提問**：「這是產品規格，幫我設計後端架構，我要用 Microservices 嗎？」
*   **Agent 產出**：
    *   **違和感偵測**：「MVP 階段搞微服務是自殺行為。請使用 Modular Monolith。」
    *   **核心診斷**：指出語音處理是 CPU/GPU 密集型，必須與 CRUD 業務邏輯分離，避免阻塞主執行緒。
    *   **架構建議**：採用「事件驅動架構 (EDA)」。上傳完成後發送 `FileUploaded` 事件，由獨立的 Worker 處理轉錄與分析，前端透過 WebSocket 接收通知。

### 第三階段：AI 核心邏輯 (AI Core Logic)
**諮詢對象**：🤖 **AI Agent 工程師**
*   **你的提問**：「如何設計這個 AI 分析流程？它需要調用 CRM API。」
*   **Agent 產出**：
    *   **Agent 拓撲**：設計 Supervisor 模式。主控 Agent 協調「轉錄員」、「分析師」與「CRM 操作員」。
    *   **工具定義**：撰寫精確的 JSON Schema 給 LLM，例如 `update_deal_stage(deal_id, stage, probability)`。
    *   **韌性設計**：加入「自我修正迴圈」，如果 LLM 產生的 JSON 格式錯誤，自動將錯誤訊息回傳給 LLM 讓其重試。

### 第四階段：實作開發 (Implementation)
**諮詢對象**：🤖 **Google 資深工程師**
*   **你的提問**：「給我後端 API 的 Go 語言實作代碼，包含 WebSocket 和 Worker。」
*   **Agent 產出**：
    *   **程式碼**：提供符合 Clean Architecture 的 Go 專案結構。
    *   **實作細節**：使用 Gin 框架寫 API，Asynq 處理背景任務，Gorilla WebSocket 處理即時通知。
    *   **最佳實踐**：加入 Graceful Shutdown 與 Structured Logging。

### 第五階段：部署與運維 (Deployment & Ops)
**諮詢對象**：🤖 **DevOps/SRE 工程師**
*   **你的提問**：「我要上線了，怎麼部署最省錢又穩？」
*   **Agent 產出**：
    *   **基礎設施**：推薦使用 GCP Cloud Run (Serverless) 部署 API 與 Worker，因為業務員使用時間集中，離峰時可縮減至 0 節省成本。
    *   **推理優化**：建議 Whisper 模型部署在 GKE Autopilot 上，並使用 Spot Instances (L4 GPU) 降低 60% 運算成本。
    *   **監控**：設定 Prometheus 監控「任務佇列長度」與「處理失敗率」，並在 Grafana 建立儀表板。

---
*Usage: 在與 AI 對話時，可將對應的 Prompt 內容貼入 System Prompt 或作為開場指令，以啟動特定的專家模式。*
