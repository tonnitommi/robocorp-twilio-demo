*** Settings ***
Library     Collections
Library     RPA.Browser.Selenium
Library     RPA.Robocorp.WorkItems
Library     RPA.Tables
Library     RPA.Notifier
Library     RPA.Robocorp.Vault

*** Tasks ***
Consume items
    For Each Input Work Item    Handle item

*** Keywords ***
Write notification log
    [Documentation]
    ...    Writes log of notification activities
    [Arguments]    ${payload}
    Log To Console    Here the robot would update records in relevant systems that ${payload["Name"]} was notified by SMS, and maybe the delivery status of the messages.


Action for item
    [Documentation]
    ...    Simulates sending an appointment reminder for one work item
    [Arguments]    ${payload}
    ${twilio}=    Get Secret    Twilio
    Log To Console    Twilio is ${twilio}[account_sid]
    IF    "${payload["Sent"]}" == "NOT"
        Log To Console    Sending to ${payload["Name"]}
        ${text}=    Catenate    Tervetuloa     ${payload["Name"]}    labroihin! Sinulle on varattu     ${payload["What"]}     Ota henkilökortti mukaan. Ilmoittautumista ei tarvita.
        Notify Twilio    message=${text}    number_from=${twilio}[number_from]    number_to=${payload["Number"]}    account_sid=${twilio}[account_sid]    token=${twilio}[token]
        Write notification log    ${payload}
    ELSE
        Log To Console    Already sent to ${payload["Name"]}
    END

Handle item
    [Documentation]    Error handling around one work item.
    ${payload}=    Get Work Item Payload
    ${Item Handled}=    Run Keyword And Return Status
    ...    Action for item    ${payload}
    IF    ${Item Handled}
        Release Input Work Item    DONE
    ELSE
        # Giving a good error message here means that data related errors can
        # be fixed faster in Control Room.
        ${error_message}=    Set Variable
        ...    Failed to handle item for: ${payload}.
        Log    ${error_message}    level=ERROR
        Release Input Work Item
        ...    state=FAILED
        ...    exception_type=BUSINESS
        ...    message=${error_message}
    END
