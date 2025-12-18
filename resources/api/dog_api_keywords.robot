*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://dog.ceo/api

*** Keywords ***
Criar Sessão Dog API
    Create Session    dog_api    ${BASE_URL}    disable_warnings=1

Listar todas as raças
    ${response}=    GET On Session    dog_api    /breeds/list/all
    RETURN    ${response}

Listar imagens da raça "${breed}"
    ${response}=    GET On Session    dog_api    /breed/${breed}/images
    RETURN    ${response}

Buscar imagem aleatória
    ${response}=    GET On Session    dog_api    /breeds/image/random
    RETURN    ${response}

Validar Estrutura de Sucesso
    [Arguments]    ${response}
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()}[status]    success