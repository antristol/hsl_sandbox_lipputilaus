*** Settings ***
Documentation    Lippujen ostamisen e2e-workflowt

Resource    ../../resources/settings.resource



*** Test Cases ***
Aikuinen, Yksittaisen Lipun Ostamisen
    [Documentation]    Yksittäisen lipun osto aikuiselle. Osto, vahvistus ja renderöinti.

    ${json}    Palauta Peruslippu Json
    ${resp}    POST ORDER TICKET    ${json}

    ${deviceId}    Generoi Uuid
    ${confirm_json}    Palauta Confirm Json    ${resp.json()}[ticketId]    ${deviceId}
    PUT CONFIRM TICKET    ${confirm_json}

    ${resp}    GET RENDER TICKET    ${resp.json()}[ticketId]    ${deviceId}
    ${ticketdata}    Pura Ja Tarkista JWT    ${resp.json()}[ticketData]

    Kirjoita Lokitiedosto    hsl_yksittainen_lippu    html    ${ticketdata}[ticket]

Aikuinen, Paivalippu, Kesto 7pv
    [Documentation]    Ostetaan päivälippu kestoltaan 7pv aikuiselle. Osto, vahvistus ja renderöinti

    ${json}    Palauta Peruslippu Json    ticketTypeId=day
    Set To Dictionary    ${json}    validityPeriod=${7}
    ${resp}    POST ORDER TICKET    ${json}

    ${deviceId}    Generoi Uuid
    ${confirm_json}    Palauta Confirm Json    ${resp.json()}[ticketId]    ${deviceId}
    PUT CONFIRM TICKET    ${confirm_json}

    ${resp}    GET RENDER TICKET    ${resp.json()}[ticketId]    ${deviceId}
    ${ticketdata}    Pura Ja Tarkista JWT    ${resp.json()}[ticketData]

    Kirjoita Lokitiedosto    hsl_paivalippu_lippu    html    ${ticketdata}[ticket]

Lapsi, Paivalippu, Kesto 13pv
    [Documentation]    Ostetaan päivälippu kestoltaan 13pv lapselle. Osto, vahvistus ja renderöinti
    ${json}    Palauta Peruslippu Json    customerTypeId=child    ticketTypeId=day
    Set To Dictionary    ${json}    validityPeriod=${13}
    ${resp}    POST ORDER TICKET    ${json}

    ${deviceId}    Generoi Uuid
    ${confirm_json}    Palauta Confirm Json    ${resp.json()}[ticketId]    ${deviceId}
    PUT CONFIRM TICKET    ${confirm_json}

    ${resp}    GET RENDER TICKET    ${resp.json()}[ticketId]    ${deviceId}
    ${ticketdata}    Pura Ja Tarkista JWT    ${resp.json()}[ticketData]

    Kirjoita Lokitiedosto    hsl_paivalippu_lippu    html    ${ticketdata}[ticket]
