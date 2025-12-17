*** Settings ***
Documentation     Testes de funcionalidade do campo de pesquisa - Desafio Técnico
# Sobe dois níveis (sai de web, sai de tests) e entra em resources
Resource          ../../resources/pesquisa_keywords.robot
Test Setup        Abrir navegador
Test Teardown     Finalizar teste

*** Test Cases ***
Cenário: Pesquisar por um termo válido
    Dado que acesso o blog do Agibank
    Quando abro a pesquisa
    E pesquiso por "Agibank"
    Então devo visualizar a página de resultados de busca

Cenário: Pesquisar por termo com caracteres especiais
    Dado que acesso o blog do Agibank
    Quando abro a pesquisa
    E pesquiso por "Cartão @ 2025"
    Então devo visualizar a página de resultados de busca

Cenário: Pesquisar por um termo inexistente
    Dado que acesso o blog do Agibank
    Quando abro a pesquisa
    E pesquiso por "BuscaInexistenteAgibank123"
    Então devo visualizar a mensagem de resultados não encontrados

Cenário: Cancelar a pesquisa
    Dado que acesso o blog do Agibank
    Quando abro a pesquisa
    E clico para fechar a pesquisa
    Então o campo de pesquisa deve desaparecer da tela