@IsTest
private with sharing class FinanceServiceTest {

    @IsTest
    static void todo() {

        Test.setMock( HttpCalloutMock.class, new FinanceServiceHttpCalloutMock() );

    }

}
