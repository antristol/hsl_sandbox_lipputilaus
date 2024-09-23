*** Settings ***
Documentation    Negatiivisiä testejä ./order endpointille
Resource    ../../resources/resources.resource


*** Test Cases ***
NEG: Order Ticket, Puhelinnumero Puuttuu
    [Documentation]    Poistetaan request bodyltä pakollinen phonenumber kenttä.
    ${json}    Palauta Peruslippu Json
    Remove From Dictionary    ${json}    phoneNumber

    ${resp}    POST ORDER TICKET    ${json}    400
    Should Contain    ${resp.json()}[message]    data/body should have required property 'phoneNumber'

NEG: Order Ticket, Vaara CustomerTypeId
    [Documentation]    Asetetaan väärän tyyppinen customerTypeId matkustajaluokan arvo.
    ${json}    Palauta Peruslippu Json
    Set To Dictionary    ${json}    customerTypeId=XXX

    ${resp}    POST ORDER TICKET    ${json}    400
    Should Contain    ${resp.json()}[message]    Invalid/Unknown customerTypeId/ticketTypeId combination

NEG: Order Ticket, Vaara Datatyyppi Parametrilla
    [Documentation]    Asetetaan request bodyn zones kenttään listassa vyöhyke
    ${json}    Palauta Peruslippu Json
    VAR    @{zone_lista}    AB
    Set To Dictionary    ${json}    zones=${zone_lista}

    ${resp}    POST ORDER TICKET    ${json}    400
    Should Contain    ${resp.json()}[message]    data/body/zones should be equal to one of the allowed values