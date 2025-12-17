*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}                https://blogdoagi.com.br/
${BROWSER}            chrome
${LUPA_PESQUISA}      id=search-open
${CAMPO_INPUT}        css:.ast-search-menu-icon.slide-search input.search-field
${BOTAO_FECHAR}       id=search-close
${RODAPE}             css:footer

*** Keywords ***
Abrir navegador
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    
    # CORREÇÃO DA SINTAXE: Passamos apenas o valor da string
    Run Keyword If    '${BROWSER}' == 'headlesschrome'    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --window-size\=1920,1080
    
    # Bypass de detecção de robô
    Call Method    ${options}    add_argument    --disable-blink-features\=AutomationControlled
    Call Method    ${options}    add_experimental_option    excludeSwitches    ${{['enable-automation']}}
    Call Method    ${options}    add_argument    --user-agent\=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
    
    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Set Selenium Timeout    30s

Finalizar teste
    # Conforme solicitado: Screenshot em cada falha ou sucesso
    Capture Page Screenshot
    Close Browser

Dado que acesso o blog do Agibank
    Go To    ${URL}
    Wait Until Page Contains Element    tag:body    timeout=30s
    Sleep    3s

Quando abro a pesquisa
    Wait Until Page Contains Element    ${LUPA_PESQUISA}    timeout=30s
    Execute Javascript    window.scrollTo(0, 0)
    # Clique via JS para ignorar bloqueios de visibilidade no modo headless
    Execute Javascript    document.getElementById('search-open').click()
    
    # Espera o campo aparecer após a animação de slide
    Wait Until Page Contains Element    ${CAMPO_INPUT}    timeout=15s
    Sleep    1s

E pesquiso por "${termo}"
    Input Text      ${CAMPO_INPUT}    ${termo}
    Press Keys      ${CAMPO_INPUT}    ENTER

E clico para fechar a pesquisa
    Wait Until Element Is Visible    ${BOTAO_FECHAR}
    Click Element    ${BOTAO_FECHAR}

Então o campo de pesquisa deve desaparecer da tela
    Wait Until Element Is Not Visible    ${CAMPO_INPUT}

Então devo visualizar a página de resultados de busca
    Wait Until Page Contains    Resultados encontrados para:    timeout=20s

Então devo visualizar a mensagem de resultados não encontrados
    Wait Until Page Contains    Lamentamos, mas nada coincide    timeout=20s