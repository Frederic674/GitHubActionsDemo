*** Settings ***
Library  SeleniumLibrary
Resource  Keywords_CA.resource
Resource  Variables_CA.resource

*** Test Cases ***
Extraction_AO
    Je me connecte à EASY
    J'extrai les données
    #J'ecris les données dans Excel  ${EXCEL_FILE}  ${SHEET_NAME}