*** Settings ***
Documentation    Projektin yleinen resurssitiedosto

Library    RequestsLibrary
Library    OperatingSystem
Library    JSONLibrary
Library    Collections
Library    DateTime

Library    ../python/keywords.py
Resource    json_sanomat.resource


*** Variables ***
${MAAS_API_KEY}
&{HEADER}          X-API-Key=${MAAS_API_KEY}

${HSL_TICKET_PUBLIC_KEY}    ${CURDIR}/public_key.json
${RESOURCES_DIR}            ${CURDIR}
${LOGS_DIR}                 ${CURDIR}/../logs

${HSL_SANDBOX_API_URL}            https://sales-api.hsl.fi/api/sandbox/ticket
${HSL_SANDBOX_ORDER_TICKET}       ${HSL_SANDBOX_API_URL}/v4/order
${HSL_SANDBOX_CONFIRM_TICKET}     ${HSL_SANDBOX_API_URL}/v4/confirm
${HSL_SANDBOX_RENDER_TICKET}      ${HSL_SANDBOX_API_URL}/v4/render


*** Keywords ***
Kirjoita Lokitiedosto
    [Documentation]    Lokitetaan parametrina annettu \${sisalto} tiedostopolkuun \${nimi}.\${tiedostomuoto}
    [Arguments]    ${nimi}    ${tiedostomuoto}    ${sisalto}
    ${timestamp}    Get Current Date  result_format=%d%m%Y_%H%M%S
    ${suite}    Korvaa Kielletyt Merkit    ${SUITE_NAME}
    ${test}    Korvaa Kielletyt Merkit    ${TEST_NAME}
    ${nimi}    Korvaa Kielletyt Merkit    ${nimi}

    Log Many    ${suite}    ${test}    ${nimi}

    Create File    ${LOGS_DIR}/${suite}/${test}/${timestamp}_${nimi}.${tiedostomuoto}    ${sisalto}

Lokita HTTP Request Ja Response
    [Documentation]    Lokitetaan HTTP sanoma testin kansioon annetulla \${loki_nimi}:llä
    [Arguments]    ${loki_nimi}    ${response}

    VAR    ${log_request}
    ...    ${response.request.method} Request url\=${response.request.url} ${\n}
    ...    headers\=${response.request.headers} ${\n}
    ...    body\=${response.request.body}

    VAR    ${log_response}
    ...    ${response.request.method} Response url\=${response.request.url} ${\n}
    ...    status\=${response.status_code} reason\=${response.reason} ${\n}
    ...    headers\=${response.headers} body\=${response.text}

    Kirjoita Lokitiedosto    ${loki_nimi}_request    txt    ${log_request}
    Kirjoita Lokitiedosto    ${loki_nimi}_response    txt    ${log_response}

POST ORDER TICKET
    [Documentation]    Lähetetään annettu \${json} sanoma ${HSL_SANDBOX_ORDER_TICKET} endpointtiin, ja tarkastetaan paluuarvo \${expected_status} vasten.
    ...    Palauta saatu vastaus.
    [Arguments]    ${json}    ${expected_status}=200
    ${resp}    POST    url=${HSL_SANDBOX_ORDER_TICKET}    json=${json}    headers=${HEADER}    expected_status=any
    Status Should Be    ${expected_status}
    RETURN    ${resp}
    [Teardown]    Lokita HTTP Request Ja Response    hsl_order_ticket    ${resp}

PUT CONFIRM TICKET
    [Documentation]    Lähetetään annettu \${json} sanoma ${HSL_SANDBOX_CONFIRM_TICKET} endpointtiin, ja tarkastetaan paluuarvo \${expected_status} vasten.
    ...    Palauta saatu vastaus.
    [Arguments]    ${json}    ${expected_status}=200

    ${resp}    PUT    url=${HSL_SANDBOX_CONFIRM_TICKET}   json=${json}    headers=${HEADER}    expected_status=any
    Status Should Be    ${expected_status}
    RETURN    ${resp}
    [Teardown]    Lokita HTTP Request Ja Response    hsl_confirm_ticket    ${resp}

GET RENDER TICKET
    [Documentation]    Tehdään haku annetuilla \${ticketId} ja \${deviceId} arvoilla, ja tarkastetaan paluuarvo \${expected_status} vasten.
    ...    Palauta saatu vastaus.
    [Arguments]    ${ticketId}    ${deviceId}    ${expected_status}=200
    # Renderöi lippu
    ${resp}    GET    url=${HSL_SANDBOX_RENDER_TICKET}?ticketId=${ticketId}&deviceId=${device_id}&locale=fi    headers=${HEADER}    expected_status=any
    Status Should Be    ${expected_status}
    RETURN    ${resp}
    [Teardown]    Lokita HTTP Request Ja Response    hsl_ticket_render    ${resp}

