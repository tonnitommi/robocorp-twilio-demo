*** Settings ***
Library     Collections
Library     RPA.Browser.Selenium
Library     RPA.Robocorp.WorkItems
Library     RPA.Excel.Files
Library     RPA.Tables
Library     RPA.Notifier
Library     RPA.Robocorp.Vault

*** Tasks ***
Appointment remind
    ${table}=    Read Appointments
    Remind Patients    ${table}

*** Keywords ***
Read Appointments
    [Documentation]
    ...    Reads excel file for appointment data
    ${path}=    Get Work Item File    orders.xlsx    %{ROBOT_ARTIFACTS}${/}orders.xlsx
    Open Workbook    ${path}
    ${table}=    Read Worksheet As Table    header=True
    [return]  ${table}

Remind Patients
    [Documentation]
    ...    Iterate through all the appointents and send notification (if needed)
    ...    using Twilio.   
    [Arguments]    ${appointments}
    ${twilio}=    Get Secret    Twilio
    Log To Console    Twilio sid is ${twilio}[account_sid]
    FOR    ${row}    IN    @{appointments}
        IF    "${row}[Send status]" == "NOT"
            Log To Console    Sending to Name=${row}[Name]
            ${text}=    Catenate    Tervetuloa     ${row}[Name]    labroihin! Sinulle on varattu     ${row}[What]     Ota henkilökortti mukaan. Ilmoittautumista ei tarvita.    
            Notify Twilio    message=${text}    number_from=${twilio}[number_from]    number_to=${row}[Number]    account_sid=${twilio}[account_sid]    token=${twilio}[token]
            Write notification log    ${row}
        ELSE
            Log To Console    Already sent to ${row}[Name]
        END
    END

Write notification log
    [Documentation]
    ...    Writes log of notification activities
    [Arguments]    ${row}
    Log To Console    Here the robot would update records in relevant systems that ${row}[Name] was notified by SMS, and log the delivery status of the messages.