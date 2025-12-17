*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}                https://blogdoagi.com.br/
${BROWSER}            chrome
${LUPA_PESQUISA}      id=search-open
${CAMPO_INPUT}        css:input.search-field
${BOTAO_FECHAR}       id=search-close

*** Keywords ***
Abrir navegador
    ${options}=    Set Variable    add_argument("--headless"); add_argument("--no-sandbox"); add_argument("--disable-dev-shm-usage")
    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Set Selenium Window Size    1920    1080

Finalizar teste
    Capture Page Screenshot
    Close Browser

Dado que acesso o blog do Agibank
    Go To    ${URL}
    Wait Until Page Contains    Agibank    timeout=30s

Quando abro a pesquisa
    Wait Until Element Is Visible    ${LUPA_PESQUISA}    timeout=30s
    Click Element    ${LUPA_PESQUISA}
    Wait Until Element Is Visible    ${CAMPO_INPUT}    timeout=15s

E pesquiso por "${termo}"
    Input Text      ${CAMPO_INPUT}    ${termo}
    Press Keys      ${CAMPO_INPUT}    ENTER

E clico para fechar a pesquisa
    Click Element    ${BOTAO_FECHAR}

Então o campo de pesquisa deve desaparecer da tela
    Wait Until Element Is Not Visible    ${CAMPO_INPUT}

Então devo visualizar a página de resultados de busca
    Wait Until Page Contains    Resultados encontrados para:    timeout=20s

Então devo visualizar a mensagem de resultados não encontrados
    Wait Until Page Contains    Lamentamos, mas nada coincide    timeout=20s