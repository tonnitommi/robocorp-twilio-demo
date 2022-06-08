*** Settings ***
Library     Collections
Library     RPA.Browser.Selenium
Library     RPA.Excel.Files
Library     RPA.Tables
Library     RPA.Notifier
Library     RPA.Robocorp.Vault
Library     RPA.Cloud.Google
...            vault_name=Google
...            vault_secret_key=service_account
Library     DateTime
Suite Setup     Init Sheets    use_robocorp_vault=True

*** Variables ***
${SHEET_READ_RANGE}          Appt!A2:C
${SHEET_WRITE_RANGE}         Log!A2:C


*** Tasks ***
Appointment remind
    ${table}=    Read Appointments
    Remind Patients    ${table}

*** Keywords ***
Read Appointments
    [Documentation]
    ...    Reads google sheet for appointment data
    ${google}=    Get Secret    Google
    ${sheet}=    Get Sheet Values     ${google}[sheet_id]      ${SHEET_READ_RANGE}
    ${table}    Set Variable    ${sheet}[values][0:]
    [return]  ${table}

Remind Patients
    [Documentation]
    ...    Iterate through all the appointents and send notification (if needed)
    ...    using Twilio.
    [Arguments]    ${appointments}
    ${twilio}=    Get Secret    Twilio
    Log To Console    Twilio sid is ${twilio}[account_sid]

    FOR    ${row}    IN    @{appointments}
        Log To Console    Sending to Name=${row}[0]

        ${text}=    Catenate    Tervetuloa     ${row}[0]    labroihin! Sinulle on varattu     ${row}[1]     Ota henkilökortti mukaan. Ilmoittautumista ei tarvita.

        Notify Twilio    message=${text}    number_from=${twilio}[number_from]    number_to=${row}[2]    account_sid=${twilio}[account_sid]    token=${twilio}[token]
        Write notification log    ${row}
    END

Write notification log
    [Documentation]
    ...    Writes log of notification activities
    [Arguments]    ${row}
    ${date}=    Get Current Date
    ${google}=    Get Secret    Google

    ${values}=    Evaluate    [["${row}[0]", "${row}[2]", "${date}"]]

    Insert Sheet Values
    ...    ${google}[sheet_id]
    ...    ${SHEET_WRITE_RANGE}
    ...    ${values}
    ...    ROWS