*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}                https://blogdoagi.com.br/
${BROWSER}            chrome
${LUPA_PESQUISA}      css:.ast-search-menu-icon
${CAMPO_INPUT}        css:input.search-field
${BOTAO_FECHAR}       id=search-close

*** Keywords ***
Abrir navegador
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    
    # Usamos o Call Method passando apenas a variável sem atribuir nomes
    Call Method    ${options}    add_argument    --disable-blink-features\=AutomationControlled
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    
    IF    '${BROWSER}' == 'headlesschrome'
        Call Method    ${options}    add_argument    --headless
    END

    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Set Selenium Timeout    30 seconds

Finalizar Teste
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