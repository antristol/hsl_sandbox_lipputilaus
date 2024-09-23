*** Settings ***
Documentation    Keywordit ja muuttujat json sanomien muodostamiseen.


*** Variables ***
# Esimerkkisanoma tilauksesta
${BASE_TICKET_ORDER_JSON}
...    {
...        "customerTypeId": "adult",
...        "phoneNumber": "+358501231234",
...        "customerTypeId": "adult",
...        "zones": "AB"
...    }

# Esimerkkisanoma lipun vahvistuksesta
${BASE_TICKET_CONFIRM_JSON}
...    {
...        "ticketId": "67890",
...        "deviceId": "12345"
...    }


*** Keywords ***
Palauta Peruslippu Json
    [Documentation]    Muodostetaaan tilaussanoma annettujen \${customerTypeId}, \${ticketTypeId}
    ...    ja \${ticket_zone} arvojen perusteella
    [Arguments]    ${customerTypeId}=adult    ${ticketTypeId}=single    ${ticket_zone}=AB
    ${base_order_json}    Convert String To Json    ${BASE_TICKET_ORDER_JSON}
    Set To Dictionary    ${base_order_json}
    ...    customerTypeId=${customerTypeId}
    ...    ticketTypeId=${ticketTypeId}
    ...    zones=${ticket_zone}
    RETURN    ${base_order_json}

Palauta Confirm Json
    [Documentation]    Muodostetaan vahvitussanoma annetun \${ticketId} ja \${deviceId} perusteella
    [Arguments]    ${ticketId}    ${deviceId}

    ${base_confirm_json}    Convert String To Json    ${BASE_TICKET_CONFIRM_JSON}
    Set To Dictionary    ${base_confirm_json}    ticketId=${ticketId}    deviceId=${deviceId}
    RETURN    ${base_confirm_json}

