*** Settings ***
Documentation    Negatiivisiä testejä ./Confirm endpointille
Resource    ../../resources/resources.resource
Test Setup    Tilaa Lippu

*** Test Cases ***
NEG: Lipun Vahvistus, DeviceID Puuttuu
    [Documentation]    Yritetään vahvistaa lippua ilman pakollista DeviceID kenttää request bodyllä.
    ${deviceId}    Generoi Uuid
    ${confirm_json}    Palauta Confirm Json    ${resp.json()}[ticketId]    ${deviceId}

    Remove From Dictionary    ${confirm_json}    deviceId

    ${confirm_resp}    PUT CONFIRM TICKET   ${confirm_json}    400
    Should Contain    ${confirm_resp.json()}[message]    data/body should have required property 'deviceId'

NEG: Lipun Vahvistus, TicketId Puuttuu
    [Documentation]    Yritetään vahvistaa lippua ilman pakollista TicketID kenttää request bodyllä.
    ${deviceId}    Generoi Uuid
    ${confirm_json}    Palauta Confirm Json    ${resp.json()}[ticketId]    ${deviceId}

    Remove From Dictionary    ${confirm_json}    ticketId

    ${confirm_resp}    PUT CONFIRM TICKET    ${confirm_json}    400
    Should Contain    ${confirm_resp.json()}[message]    data/body should have required property 'ticketId'

NEG: Lipun Vahvistus, TicketId Eroaa Tilauksen TicketId Arvosta
    [Documentation]    Yritetään vahvistaa eri ticketid:llä lippua, kuin mitä tilauksen yhteydessä palautui.
    ${deviceId}    Generoi Uuid
    ${confirm_json}    Palauta Confirm Json    ${resp.json()}[ticketId]    ${deviceId}

    Set To Dictionary    ${confirm_json}    ticketId=123

    ${confirm_resp}    PUT CONFIRM TICKET   ${confirm_json}    403
    Should Contain    ${confirm_resp.json()}[message]    NOTHING_TO_CONFIRM


*** Keywords ***
Tilaa Lippu
    [Documentation]    Tilaa lippu, ja aseta saatu vastaus testidataksi testimuuttujana.
    ${json}    Palauta Peruslippu Json
    ${resp}    POST ORDER TICKET    ${json}
    VAR    ${RESP}    ${resp}    scope=TEST