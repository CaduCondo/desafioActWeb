# 🚀 Desafio ACT - Automação Full Stack (Web)

Este repositório apresenta uma solução robusta para o desafio técnico de automação, integrando testes de interface (E2E) utilizando o ecossistema **Robot Framework**.

---

## 🛠️ Configuração e Requisitos

| Requisito | Versão Mínima | Finalidade |
| :--- | :--- | :--- |
| **Python** | 3.10+ | Linguagem base do projeto |
| **Google Chrome** | Atualizada | Navegador para execução Web local |
| **ChromeDriver** | Compatível | Driver para comunicação com o browser |

### 📥 Instalação
1. Clone o repositório.
2. Na raiz do projeto, instale as dependências:
   ```bash
   pip install -r requirements.txt
   

## 📂 Estrutura de Pastas

O projeto utiliza uma estrutura modular para separar as tecnologias e contextos de teste:

|text|
|├── resources/           # Keywords e Variáveis (Lógica de Teste)|
|│   ├── web/             # Recursos do Blog Agibank (Selenium)|
|│   └── api/             # Recursos da Dog API (Requests)|
|├── tests/               # Casos de Teste (Cenários BDD)|
|│   ├── web/             # Automação de Interface (UI)|
|│   └── api/             # Automação de Integração (API)|
|├── results/             # Relatórios, Logs e Screenshots|
|├── requirements.txt     # Dependências do projeto (Python)|
|└── README.md            # Documentação principal|


## 🌐 Projeto 01: Automação Web (Blog Agibank)

**Objetivo**: Validar a resiliência e funcionalidade do sistema de busca do Blog do Agibank.
**Tecnologia**: Robot Framework + SeleniumLibrary.

|🧪 **Cenários de Teste**|
|[x] Pesquisa por termos válidos: Garante o retorno de artigos existentes.|
|[x] Pesquisa por caracteres especiais: Valida a segurança e tratamento do input.|
|[x] Pesquisa por termos inexistentes: Valida a mensagem de "Nada encontrado".|
|[x] Interação UI: Valida o comportamento de abertura e fechamento do campo de busca.|

### Como rodar os testes:
bash
robot -d results .


## 📊 Resultados e Evidências
Após a execução, os artefatos estarão disponíveis na pasta /results:

**report.html**: Visão executiva dos testes.
**log.html**: Detalhamento técnico e screenshots de cada passo.