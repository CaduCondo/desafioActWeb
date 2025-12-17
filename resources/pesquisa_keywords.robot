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
*** Keywords ***
Abrir navegador
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Run Keyword If    '${BROWSER}' == 'headlesschrome'    Call Method    ${options}    add_argument    --headless
    
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --window-size\=1920,1080
    
    # ESTES ARGUMENTOS SÃO CRICIAIS PARA SITES COM BLOQUEIO (WAF)
    Call Method    ${options}    add_experimental_option    excludeSwitches    ${{['enable-automation']}}
    Call Method    ${options}    add_argument    --disable-blink-features\=AutomationControlled
    Call Method    ${options}    add_argument    --user-agent\=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
    
    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Set Selenium Timeout    30s

Quando abro a pesquisa
    # 1. Espera a lupa e clica via JS (já está funcionando)
    Wait Until Page Contains Element    id=search-open    timeout=30s
    Execute Javascript    document.getElementById('search-open').click()
    
    # 2. Em vez de 'Wait Until Element Is Visible', usamos 'Contains Element'
    # e damos um tempo para a animação do CSS terminar no modo headless
    Wait Until Page Contains Element    ${CAMPO_INPUT}    timeout=15s
    Sleep    2s
    
    # 3. Força o foco no campo via JS para garantir que o Input Text funcione
    Execute Javascript    document.querySelector('.ast-search-menu-icon.slide-search input.search-field').focus()

Finalizar teste
    Capture Page Screenshot
    Close Browser

Dado que acesso o blog do Agibank
    Go To    ${URL}
    # Espera o rodapé para garantir que a página carregou o conteúdo
    Wait Until Page Contains Element    ${RODAPE}    timeout=30s

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