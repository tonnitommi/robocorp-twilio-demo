*** Settings ***
Library     Collections
Library     RPA.Browser.Selenium
Library     RPA.Excel.Files
Library     RPA.Tables
Library     RPA.Notifier
Library     RPA.Robocorp.Vault
Library    DateTime

*** Tasks ***
Appointment remind
    ${table}=    Read Appointments
    Remind Patients    ${table}

*** Keywords ***
Read Appointments
    [Documentation]
    ...    Reads excel file for appointment data
    Open Workbook    orders.xlsx
    ${table}=    Read Worksheet As Table    name=Appt    header=True
    [return]  ${table}

Remind Patients
    [Documentation]
    ...    Iterate through all the appointents and send notification (if needed)
    ...    using Twilio.   
    [Arguments]    ${appointments}
    ${twilio}=    Get Secret    Twilio
    Log To Console    Twilio sid is ${twilio}[account_sid]
    FOR    ${row}    IN    @{appointments}
        Log To Console    Sending to Name=${row}[Name]
        ${text}=    Catenate    Tervetuloa     ${row}[Name]    labroihin! Sinulle on varattu     ${row}[What]     Ota henkilökortti mukaan. Ilmoittautumista ei tarvita.    
        Notify Twilio    message=${text}    number_from=${twilio}[number_from]    number_to=${row}[Number]    account_sid=${twilio}[account_sid]    token=${twilio}[token]
        Write notification log    ${row}
    END

Write notification log
    [Documentation]
    ...    Writes log of notification activities
    [Arguments]    ${row}
    ${date}=    Get Current Date
    Open Workbook    orders.xlsx
    @{table_name}=    Create List    ${row}[Name]
    @{table_number}=    Create List    ${row}[Number]
    @{table_datetime}=    Create List    ${date}
    &{table}=    Create Dictionary    Name=${table_name}    Number=${table_number}    Datetime=${table_datetime}
    Create Table    ${table}
    Log To Console    ${table}
    Append rows to worksheet    ${table}   Log
    Save Workbook