@IsTest
private class FinanceServiceTest {

    @IsTest
    static void testGetStockInfo_success() {

        // Tests cannot make actual callouts, so we must mock them.
        // As a unit test, we are asserting our code's behavior to
        // specific kinds of responses that our mock class provides.
        Test.setMock( HttpCalloutMock.class, new FinanceServiceHttpCalloutMock() );

        Test.startTest();

        FinanceService service = new FinanceService();
        FinanceService.StockInfo info = service.getStockInfoForSymbol( 'CRM' );

        Test.stopTest();

        System.assertEquals( 'CRM', info.symbol );
        System.assertEquals( Date.valueOf( '2019-04-25' ), info.lastRefreshedDate );
        System.assertEquals( 120, info.openPrice );
        System.assertEquals( 150, info.highPrice );
        System.assertEquals( 100, info.lowPrice );
        System.assertEquals( 130, info.closePrice );

    }

    @IsTest
    static void testGetStockInfo_failure() {

        // Tests cannot make actual callouts, so we must mock them.
        // As a unit test, we are asserting our code's behavior to
        // specific kinds of responses that our mock class provides.
        Test.setMock( HttpCalloutMock.class, new FinanceServiceHttpCalloutMock() );

        Test.startTest();

        try {

            FinanceService service = new FinanceService();
            FinanceService.StockInfo info = service.getStockInfoForSymbol( 'ERROR' );

            System.assert( false, 'did not throw exception' );

        } catch ( FinanceService.FinanceException e ) {

            System.assert( true );

        } catch ( Exception e ) {

            System.assert( false, 'incorrect exception thrown' );

        }

        Test.stopTest();

    }

}
