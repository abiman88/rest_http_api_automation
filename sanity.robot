*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Variables         variable.py

*** Variables ***

*** Test Cases ***
Get Request Test
    [Documentation]    Test case to check if URI is responding
    [Tags]    Connectivity Test
    ${response}=    GET    ${URI}
    Status Should Be    OK    ${response}
    Log    TC is Success

Get Request Test Valid Response
    [Documentation]    Test case to check if URI is responding Valid JSON response
    [Tags]    Functionality Test
    ${response}=    GET    ${URI}
    Status Should Be    OK    ${response}
    Evaluate    json.dumps(${response.json()})    json
    Log    TC is Success

Get Response Pagination
    [Documentation]    Test case to check if URI is responding with all the mandatory fields in pagination tab
    [Tags]    Functionality Test
    Log    ${pagination}
    ${resp}=    GET    ${URI}
    Status Should Be    OK    ${resp}
    FOR    ${pagekey}    IN    @{pagination}
        Log    ${pagekey}
        ${val}=    Get This Value From Dictionary    ${resp.json()}[meta][pagination]    ${pagekey}
        Should Not Be Equal    '${val}'    'None'
    END
    Log    TC is Success

Get Response Data
    [Documentation]    Test case to check if URI is responding with all the mandatory fields in data tab
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
    Log    TC is Success

Get Response Valid Email Address
    [Documentation]    Test case to check if URI is responding with valid email address
    [Tags]    Functionality Test
    Log    ${data}
    ${resp}=    GET    ${URI}
    Status Should Be    OK    ${resp}
    FOR    ${datas}    IN    @{resp.json()}[data]
        Log    ${datas}
        ${val}=    Get From Dictionary    ${datas}    email
        Should Not Be Equal    '${val}'    'None'
        Should Match Regexp    ${val}    [A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}
    END
    Log    TC is Success

Get Response Code 404
    [Documentation]    Test case to check URI response code Not Found
    [Tags]    Connectivity Test
    ${response}=    GET    ${URI}
    Log    ${response.reason}
    Should Not Be Equal As Integers    404    ${response.status_code}
    Log    TC is Success

Get Response Code 401
    [Documentation]    Test case to check URI response code Unauthorized
    [Tags]    Connectivity Test
    ${response}=    GET    ${URI}
    Log    ${response.reason}
    Should Not Be Equal As Integers    401    ${response.status_code}
    Log    TC is Success

Get Response Code 500
    [Documentation]    Test case to check URI response code Internal Server Error
    [Tags]    Connectivity Test
    ${response}=    GET    ${URI}
    Log    ${response.reason}
    Should Not Be Equal As Integers    500    ${response.status_code}
    Log    TC is Success

Get Response Code 503
    [Documentation]    Test case to check URI response code Service Unavailable
    [Tags]    Connectivity Test
    ${response}=    GET    ${URI}
    Log    ${response.reason}
    Should Not Be Equal As Integers    503    ${response.status_code}
    Log    TC is Success

Get Request Authorisation Header
    [Documentation]    Test case to check if URI is sending with Authorisation Header
    [Tags]    Functionality Test
    ${headers}    Create Dictionary    Authorization=Bearer abcde
    ${response}=    GET    ${URI}    headers=${headers}
    Status Should Be    OK    ${response}
    Log    TC is Success

*** Keywords ***
Get This Value From Dictionary
    [Arguments]    ${Dictionary Name}    ${Key}
    ${KeyIsPresent}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${Dictionary Name}    ${Key}
    ${Value}=    Run Keyword If    ${KeyIsPresent}    Get From Dictionary    ${Dictionary Name}    ${Key}
    Return From Keyword    ${Value}
