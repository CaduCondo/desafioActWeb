*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}                https://blogdoagi.com.br/
${BROWSER}            chrome
${LUPA_PESQUISA}      id=search-open
${CAMPO_INPUT}        css:.ast-search-menu-icon.slide-search input.search-field
${BOTAO_FECHAR}       id=search-close
${RODAPE}             id=colophon

*** Keywords ***
Abrir navegador
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Run Keyword If    '${BROWSER}' == 'headlesschrome'    Call Method    ${options}    add_argument    --headless
    
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    # Força a resolução Full HD para garantir que a lupa de Desktop apareça
    Call Method    ${options}    add_argument    --window-size\=1920,1080
    # Desabilita a flag que avisa o site que é um robô
    Call Method    ${options}    add_argument    --disable-blink-features\=AutomationControlled
    
    Open Browser    ${URL}    ${BROWSER}    options=${options}

Dado que acesso o blog do Agibank
    Go To    ${URL}
    # Em vez de esperar só a página, esperamos um elemento que fica no final da página (Footer ou posts)
    # Isso garante que o conteúdo carregou
    Wait Until Page Contains Element    css:footer    timeout=30s
    # Um pequeno scroll ajuda a "acordar" o carregamento preguiçoso (lazy loading)
    Execute Javascript    window.scrollTo(0, 500)
    Sleep    2s

Quando abro a pesquisa
    # 1. Aguarda a página estabilizar
    Wait Until Keyword Succeeds    3x    5s    Page Should Contain Element    xpath://a[contains(@class, 'search-field')]|id=search-open
    
    # 2. Tenta o clique via JavaScript usando múltiplos seletores comuns do tema
    # Isso cobre tanto a versão desktop quanto possíveis variações do tema
    Execute Javascript    
    ...    var el = document.getElementById('search-open') || document.querySelector('.ast-search-menu-icon a');
    ...    if(el) { el.click(); }

    # 3. Aguarda o input aparecer
    Wait Until Element Is Visible    ${CAMPO_INPUT}    timeout=15s

Finalizar teste
    # Tira print sempre, conforme solicitado (sucesso ou falha)
    Capture Page Screenshot
    Close Browser

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