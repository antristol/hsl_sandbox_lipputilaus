*** Settings ***
Documentation    Negatiivisiä testejä ./render endpointille
Resource    ../../resources/settings.resource
Test Setup    Tilaa Ja Vahvista Lippu

*** Test Cases ***
NEG: Renderointi DeviceId Ei Vastaa Vahvistuksessa Kaytettya DeviceID Arvoa
    [Documentation]    Aseta DeviceID arvoon, joka ei vastaa tilauksessa ja vahvistuksessa käytettyä arvoa
    ${render_resp}    GET RENDER TICKET    ${RESP.json()}[ticketId]    12345    expected_status=404
    Should Contain    ${render_resp.json()}[message]    NO_TICKET_FOUND

NEG: Renderointi TicketId Ei Vastaa Vahvistuksessa Kaytettya TicketID Arvoa
    [Documentation]    Aseta TicketID arvoon, joka ei vastaa tilauksessa ja vahvistuksessa käytettyä arvoa
    ${render_resp}    GET RENDER TICKET    12345    ${DEVICEID}    expected_status=404
    Should Contain    ${render_resp.json()}[message]    NO_TICKET_FOUND


*** Keywords ***
Tilaa Ja Vahvista Lippu
    [Documentation]    Tilaa lippu ja vahvista lippu. Aseta saatu vahvistuksen endpointin
    ...    vastaus testidataksi testimuuttujana.
    ${json}    Palauta Peruslippu Json
    ${resp}    POST ORDER TICKET    ${json}

    ${deviceId}    Generoi Uuid
    ${confirm_json}    Palauta Confirm Json    ${resp.json()}[ticketId]    ${deviceId}
    PUT CONFIRM TICKET    ${confirm_json}

    VAR    ${RESP}    ${resp}    scope=TEST
    VAR    ${DEVICEID}    ${deviceId}    scope=TEST