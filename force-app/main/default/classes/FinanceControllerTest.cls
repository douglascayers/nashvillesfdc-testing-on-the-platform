@IsTest
private class FinanceControllerTest {

    @IsTest
    static void testWhenSymbolBlankThenGetNull() {

        Test.startTest();

        System.assertEquals( null, FinanceController.getStockInfoForSymbol( null ) );
        System.assertEquals( null, FinanceController.getStockInfoForSymbol( '' ) );
        System.assertEquals( null, FinanceController.getStockInfoForSymbol( '  ' ) );

        Test.stopTest();

    }

    @IsTest
    static void testWhenSymbolValidThenGetInfo() {

        // Tests cannot make actual callouts, so we must mock them.
        // As a unit test, we are asserting our code's behavior to
        // specific kinds of responses that our mock class provides.
        Test.setMock( HttpCalloutMock.class, new FinanceServiceHttpCalloutMock() );

        Test.startTest();

        FinanceService.StockInfo info = FinanceController.getStockInfoForSymbol( 'CRM' );

        Test.stopTest();

        System.assertEquals( 'CRM', info.symbol );
        System.assertEquals( Date.valueOf( '2019-04-25' ), info.lastRefreshedDate );
        System.assertEquals( 120, info.openPrice );
        System.assertEquals( 150, info.highPrice );
        System.assertEquals( 100, info.lowPrice );
        System.assertEquals( 130, info.closePrice );

    }

}
