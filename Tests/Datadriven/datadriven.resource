*** Settings ***
Documentation    Resurssitiedosto datadriven testeille.
Resource    ../../resources/json_sanomat.resource


*** Keywords ***
Datadriven Test Template
    [Documentation]    Testataan lipun ostaminen, vahvistaminen ja tulostus annetuilla
    ...    annetuilla asiakastyyppi ja lippuvyöhyke arvoilla.
    ...
    [Arguments]    ${customer_type}    ${zone}
    ${json}    Palauta Peruslippu Json    customerTypeId=${customer_type}    ticket_zone=${zone}
    Set To Dictionary    ${json}
    ...    customerTypeId=${customer_type}
    ...    zones=${zone}
    ${resp}    POST ORDER TICKET    ${json}

    ${deviceId}    Generoi Uuid
    ${confirm_json}    Palauta Confirm Json    ${resp.json()}[ticketId]    ${deviceId}
    PUT CONFIRM TICKET    ${confirm_json}

    ${resp}    GET RENDER TICKET    ${resp.json()}[ticketId]    ${deviceId}
    ${ticketdata}    Pura Ja Tarkista JWT    ${resp.json()}[ticketData]

    Kirjoita Lokitiedosto    hsl_kertalippu_vyohyke_${zone}    html    ${ticketdata}[ticket]