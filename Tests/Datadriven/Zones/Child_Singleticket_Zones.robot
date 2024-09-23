*** Settings ***
Documentation    Testataan lapsen kertalipun ostoa käytössä olevilla vyöhykkeillä.
Resource    ../datadriven.resource
Resource    ../../../resources/settings.resource
Test Template    Datadriven Test Template


*** Test Cases ***                   Asiakastyyppi    Vyöhyke
Kertalippu, Lapsi, Vyohyke AB        child            AB
Kertalippu, Lapsi, Vyohyke BC        child            BC
Kertalippu, Lapsi, Vyohyke D         child            D
Kertalippu, Lapsi, Vyohyke ABC       child            ABC
Kertalippu, Lapsi, Vyohyke CD        child            CD
Kertalippu, Lapsi, Vyohyke BCD       child            BCD
Kertalippu, Lapsi, Vyohyke ABCD      child            ABCD
