# rest_http_api_automation
The Automation suite for HTTP REST API Sanity Testing
For Running this suite please use below command
# robot --log ../reports/log.html --report ../reports/report.html --output ../reports/output.xml --variablefile=variable.py sanity.robot

Following Testcases are supported:
1. Connectivity Test
2. Valid JSON response Check
3. Pagination mandatory fields check
4. Data mandatory fields check
5. Email Address Validation
6. HTTP Response Code check
7. No authentication Check 
Note: implemented json validation using jsonschema library. Due to limitation in python version installed in  my system, not able to implement test cases robotframework-jsonvalidator library.
