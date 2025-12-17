*** Settings ***
Resource    ../../resources/api/dog_api_keywords.robot
Suite Setup    Criar Sessão Dog API

*** Test Cases ***
Cenário 01: Listar todas as raças com sucesso
    ${res}=    Listar todas as raças
    Validar Estrutura de Sucesso    ${res}
    # Valida se a lista de raças não está vazia
    ${total_racas}=    Get Length    ${res.json()}[message]
    Should Be True    ${total_racas} > 0

Cenário 02: Listar imagens de uma raça específica (Hound)
    ${res}=    Listar imagens da raça "hound"
    Validar Estrutura de Sucesso    ${res}
    # Valida se o retorno contém links de imagens
    Should Contain    ${res.json()}[message][0]    https://images.dog.ceo/breeds/

Cenário 03: Buscar uma imagem aleatória de cachorro
    ${res}=    Buscar imagem aleatória
    Validar Estrutura de Sucesso    ${res}
    Should Match Regexp    ${res.json()}[message]    ^https://.*\\.(jpg|jpeg|png)$

Cenário: Validar erro ao buscar raça inexistente
    ${res}=    GET On Session    dog_api    /breed/raca_fantasma/images    expected_status=404
    Should Be Equal As Strings    ${res.json()}[status]    error
    Should Be Equal As Strings    ${res.json()}[message]   Breed not found (master breed does not exist)

Cenário: Validar tempo de resposta (SLA)
    ${res}=    GET On Session    dog_api    /breeds/image/random
    # Converte o tempo de segundos para milissegundos
    ${response_time}=    Convert To Number    ${res.elapsed.total_seconds() * 1000}
    Should Be True    ${response_time} < 1000    O tempo de resposta foi ${response_time}ms, acima do limite de 1s.

Cenário: Validar se o retorno é um JSON válido
    ${res}=    GET On Session    dog_api    /breeds/list/all
    ${content_type}=    Get From Dictionary    ${res.headers}    Content-Type
    Should Contain    ${content_type}    application/json