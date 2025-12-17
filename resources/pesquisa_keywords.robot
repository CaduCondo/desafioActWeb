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
    
    # Configurações de estabilidade para CI
    Run Keyword If    '${BROWSER}' == 'headlesschrome'    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --window-size\=1920,1080
    # Impede que o site identifique o robô e bloqueie o conteúdo
    Call Method    ${options}    add_argument    --disable-blink-features\=AutomationControlled
    Call Method    ${options}    add_argument    --user-agent\=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
    
    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Set Selenium Timeout    30s

Finalizar teste
    Capture Page Screenshot
    Close Browser

Dado que acesso o blog do Agibank
    Go To    ${URL}
    # Espera o rodapé para garantir que a página carregou o conteúdo
    Wait Until Page Contains Element    ${RODAPE}    timeout=30s

Quando abro a pesquisa
    # O nome correto para a SeleniumLibrary é este abaixo:
    Wait Until Page Contains Element    ${LUPA_PESQUISA}    timeout=30s
    
    # Scroll para o topo para garantir visibilidade do header
    Execute Javascript    window.scrollTo(0, 0)
    
    # Clique via JS para evitar problemas de renderização no CI
    Execute Javascript    document.getElementById('search-open').click()
    
    # Aguarda o campo de digitação aparecer
    Wait Until Element Is Visible    ${CAMPO_INPUT}    timeout=15s

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