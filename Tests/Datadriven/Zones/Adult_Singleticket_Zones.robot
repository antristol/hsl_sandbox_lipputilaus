*** Settings ***
Documentation    Testataan aikuisen kertalipun ostoa käytössä olevilla vyöhykkeillä.
Resource    ../datadriven.resource
Resource    ../../../resources/settings.resource
Test Template    Datadriven Test Template


*** Test Cases ***                    Asiakastyyppi    Vyöhyke
Kertalippu, Aikuinen, Vyohyke AB      adult            AB
Kertalippu, Aikuinen, Vyohyke BC      adult            BC
Kertalippu, Aikuinen, Vyohyke D       adult            D
Kertalippu, Aikuinen, Vyohyke ABC     adult            ABC
Kertalippu, Aikuinen, Vyohyke CD      adult            CD
Kertalippu, Aikuinen, Vyohyke BCD     adult            BCD
Kertalippu, Aikuinen, Vyohyke ABCD    adult            ABCD