# 🚀 Desafio ACT - Automação Full Stack (Web & API)

Este repositório contém a solução do desafio técnico de automação, integrando testes de interface visual (Web) e testes de serviços (API) utilizando o framework **Robot Framework**.

---

## 🛠️ Configuração e Requisitos
### Pré-requisitos
Python 3.10 ou superior.
Navegador Google Chrome (para execução Web local).


## 📂 Estrutura de Pastas

O projeto utiliza uma estrutura modular para separar as tecnologias e contextos de teste:

```text
├── resources/           # Keywords e Variáveis (Lógica de Teste)
│   ├── web/             # Recursos do Blog Agibank (Selenium)
│   └── api/             # Recursos da Dog API (Requests)
├── tests/               # Casos de Teste (Cenários BDD)
│   ├── web/             # Automação de Interface (UI)
│   └── api/             # Automação de Integração (API)
├── results/             # Relatórios, Logs e Screenshots
├── requirements.txt     # Dependências do projeto (Python)
└── README.md            # Documentação principal


## 🌐 Projeto 01: Automação Web (Blog Agibank)

**Objetivo:** Validar as funcionalidades de pesquisa no [Blog do Agibank](https://blogdoagi.com.br/).
**Tecnologia:** Robot Framework + SeleniumLibrary.

### O que é testado:
* Pesquisa por termos válidos.
* Pesquisa por termos com caracteres especiais.
* Pesquisa por termos inexistentes (Fluxo de exceção).
* Funcionalidade de abrir e fechar o campo de busca.

### Como rodar apenas os testes Web:
```bash
robot -d results -v BROWSER:chrome tests/web/


## 🌐 Projeto 02: Automação de API (Dog API)

**Objetivo:** Validar o contrato e o funcionamento dos endpoints da Dog API.
**Tecnologia:** Robot Framework + SeleniumLibrary.

### Os Endpoints Testados:
GET /breeds/list/all: Valida a listagem completa de todas as raças de cães.
GET /breed/{breed}/images: Verifica se o endpoint retorna a lista de imagens de uma raça específica (ex: Hound).
GET /breeds/image/random: Valida o fornecimento de uma imagem aleatória e se a URL retornada é válida.

### Como rodar apenas os testes Web:
```bash
robot -d results tests/api/