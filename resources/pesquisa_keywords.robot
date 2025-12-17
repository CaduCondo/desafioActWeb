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
    
    # Configurações essenciais para evitar o "bloqueio de página em branco" no CI
    Run Keyword If    '${BROWSER}' == 'headlesschrome'    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --window-size\=1920,1080
    
    # MUITO IMPORTANTE: Define um User-Agent real para o site carregar o conteúdo
    Call Method    ${options}    add_argument    --user-agent\=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
    
    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Set Selenium Timeout    30s

Dado que acesso o blog do Agibank
    Go To    ${URL}
    # Em vez de esperar só a página, esperamos um elemento que fica no final da página (Footer ou posts)
    # Isso garante que o conteúdo carregou
    Wait Until Page Contains Element    css:footer    timeout=30s
    # Um pequeno scroll ajuda a "acordar" o carregamento preguiçoso (lazy loading)
    Execute Javascript    window.scrollTo(0, 500)
    Sleep    2s

Quando abro a pesquisa
    # Se o ID falhar, tentamos clicar via seletor de classe que é mais estável no tema do Agibank
    Wait Until Page Contains Element    id=search-open    timeout=30s
    # Usamos o clique via JS que você já viu que funciona melhor no CI
    Execute Javascript    document.getElementById('search-open').click()
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