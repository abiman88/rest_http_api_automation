*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem

*** Variables ***

*** Test Cases ***
Get Request Test
    [Tags]    Connectivity Test
    ${response}=    GET    ${URI}
    Status Should Be    OK    ${response}

Get Request Test Valid Response
    [Tags]    Functionality Test
    ${response}=    GET    ${URI}
    Status Should Be    OK    ${response}
    Evaluate    json.dumps(${response.json()})    json

Get Response Pagination
    [Tags]    Functionality Test
    Log    ${pagination}
    ${resp}=    GET    ${URI}
    Status Should Be    OK    ${resp}
    FOR    ${pagekey}    IN    @{pagination}
        Log    ${pagekey}
        ${val}=    Get This Value From Dictionary    ${resp.json()}[meta][pagination]    ${pagekey}
        Should Not Be Equal    '${val}'    'None'
    END
    Log    content is available

Get Response Data
    [Tags]    Functionality Test
    Log    ${data}
    ${resp}=    GET    ${URI}
    Status Should Be    OK    ${resp}
    FOR    ${datas}    IN    @{resp.json()}[data]
    Log    ${datas}
    FOR    ${dt}    IN    @{data}
        Log    ${dt}
        ${val}=    Get This Value From Dictionary    ${datas}    ${dt}
        Should Not Be Equal    '${val}'    'None'
    END
    END
    Log    content is available

*** Keywords ***
Get This Value From Dictionary
    [Arguments]    ${Dictionary Name}    ${Key}
    ${KeyIsPresent}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${Dictionary Name}    ${Key}
    ${Value}=    Run Keyword If    ${KeyIsPresent}    Get From Dictionary    ${Dictionary Name}    ${Key}
    Return From Keyword    ${Value}
