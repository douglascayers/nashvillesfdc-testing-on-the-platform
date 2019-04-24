Scenario:
    - Account Process Bulider
        o when Rating changes, post funny message to Chatter

    - AccountTrigger, AccountTriggerHandler, AccountTriggerHandlerTest
        o when Ticker Symbol changes, set StockClosePrice__c to null, set StockLastRefreshedDate__c to null

    - FinanceService, FinanceServiceTest, FinanceServiceHttpCalloutMock
        o calls out to web service to get last refreshed date and prices
        o updates StockClosePrice__c and StockLastRefreshedDate__c if either is null

    - FinanceController, FinanceControllerTest
        o AuraEnabled method that calls web service and returns current price

    - <c:finance-stock-ticker symbol={symbol}>


Unit Testing Apex
    - test a specific method
    - test mock callout

Integration Testing Apex
    - test a trigger
    - test process builder

Unit Testing LWC
    - jest tests

Browser Testing
    - puppeteer
    - ghost inspector

Continuous Integration
    - script to automate apex tests
    - script to automate jest tests
    - script to create scratch org, pass creds to ghost inspector suite