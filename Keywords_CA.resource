*** Settings ***
Library  SeleniumLibrary
Library  ExcelLibrary
Library  Collections
Library  String
Library  re
Resource  Variables_CA.resource

*** Variables ***
${ALL_DATA_GLOBAL}

*** Keywords ***
Je me connecte à EASY
    Open Browser  ${URL}  ${BROWSER}
    Input Text  xpath=//*[@id="body_x_txtLogin"]  ${USER}
    Input Password  xpath=//*[@id="body_x_txtPass"]  ${PASSWORD}
    Click Button  xpath=//*[@id="body_x_btnLogin"]

Get Number of Pages
    ${pages}=    Get Text    xpath=//span[@class='total_pages']
    RETURN    ${pages}


J'extrai les données
    ${all_data}=    Create List
    @{rows}    Create List
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'iv-grid')]//tr    timeout=10s
    ${rows}=    Get WebElements    xpath=//*[@id="body_x_grid_grd"]//tr  # Récupère toutes les lignes du tableau
    Log  ${rows}

    FOR    ${row}    IN    @{rows}
    ${columns}=    Get WebElements    xpath=.//td   # Récupère les colonnes de cette ligne
    ${row_data}=    Create List

    FOR    ${column}    IN    @{columns}
        ${cell_text}=    Get Text    ${column}
        Append To List    ${row_data}    ${cell_text}
    END

    Append To List    ${all_data}    ${row_data}
    END
    Log  Liste complète : ${all_data}    console=True
    
    Set Global Variable  ${ALL_DATA_GLOBAL}  ${all_data}  
    Log  ${ALL_DATA_GLOBAL}

J'ecris les données dans Excel
    [Documentation]    Écrire les données extraites dans un fichier Excel

     [Arguments]    ${EXCEL_FILE}    ${SHEET_NAME}
    
    Open Excel Document    ${EXCEL_FILE}   ${SHEET_NAME}  #doc_id=excel1    if_not_exists=True
    
    ${length}=    Get Length    ${ALL_DATA_GLOBAL}
    Log    Nombre de lignes à écrire : ${length}    console=True

    FOR    ${index}    IN RANGE    0    ${length}
        ${row_data}=    Set Variable    ${ALL_DATA_GLOBAL}[${index}]
        Log    Données ligne ${index} : ${row_data}    console=True

        # Écriture dans Excel
        Write Excel Row    row=${index + 1}  ${row_data}   col=1    name=${SHEET_NAME}
    END

    Save Excel Document    ${EXCEL_FILE}    #doc_id=excel1
    Close All Excel Documents    #doc_id=excel1