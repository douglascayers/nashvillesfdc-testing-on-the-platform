@IsTest
private class AccountTriggerHandlerTest {

    /**
     * Example of a unit test.
     * We assert behavior of a specific method,
     * regardless the context the method is invoked.
     */
    @IsTest
    static void testClearStockFields() {

        String tickerSymbol = 'CRM';
        Decimal stockClosePrice = 100.0;
        Date stockLastRefreshedDate = Date.today().addDays(-1);

        Account acct = new Account(
            Name = 'Test Account',
            TickerSymbol = tickerSymbol,
            StockClosePrice__c = stockClosePrice,
            StockLastRefreshedDate__c = stockLastRefreshedDate
        );

        // assert initial values
        System.assertEquals( stockClosePrice, acct.StockClosePrice__c );
        System.assertEquals( stockLastRefreshedDate, acct.StockLastRefreshedDate__c );

        Test.startTest();

        AccountTriggerHandler.clearStockFields( acct );

        Test.stopTest();

        // assert side effects
        System.assertEquals( tickerSymbol, acct.TickerSymbol );
        System.assertEquals( null, acct.StockClosePrice__c );
        System.assertEquals( null, acct.StockLastRefreshedDate__c );

    }

    /**
     * Example of a trigger test.
     * When DML occurs, then assert side effects.
     */
    @IsTest
    static void whenTickerChangesThenStockFieldsWillBeNull() {

        String tickerSymbol = 'CRM';
        Decimal stockClosePrice = 100.0;
        Date stockLastRefreshedDate = Date.today().addDays(-1);

        Account acct = new Account(
            Name = 'Test Account',
            TickerSymbol = tickerSymbol,
            StockClosePrice__c = stockClosePrice,
            StockLastRefreshedDate__c = stockLastRefreshedDate
        );

        System.assertEquals( tickerSymbol, acct.TickerSymbol );
        System.assertEquals( stockClosePrice, acct.StockClosePrice__c );
        System.assertEquals( stockLastRefreshedDate, acct.StockLastRefreshedDate__c );

        Test.startTest();

        // unlike our unit test above that explicitly calls a method to assert its action,
        // for trigger integration tests, we perform DML then assert the side effects.

        insert acct;

        // assert initial values
        acct = [ SELECT Id, TickerSymbol, StockClosePrice__c, StockLastRefreshedDate__c FROM Account WHERE Id = :acct.Id ];
        System.assertEquals( tickerSymbol, acct.TickerSymbol );
        System.assertEquals( stockClosePrice, acct.StockClosePrice__c );
        System.assertEquals( stockLastRefreshedDate, acct.StockLastRefreshedDate__c );

        update acct;

        // assert values are unchanged since ticker symbol did not change
        acct = [ SELECT Id, TickerSymbol, StockClosePrice__c, StockLastRefreshedDate__c FROM Account WHERE Id = :acct.Id ];
        System.assertEquals( tickerSymbol, acct.TickerSymbol );
        System.assertEquals( stockClosePrice, acct.StockClosePrice__c );
        System.assertEquals( stockLastRefreshedDate, acct.StockLastRefreshedDate__c );

        acct.TickerSymbol = 'BTXT';
        update acct;

        // assert side effects
        acct = [ SELECT Id, TickerSymbol, StockClosePrice__c, StockLastRefreshedDate__c FROM Account WHERE Id = :acct.Id ];
        System.assertEquals( 'BTXT', acct.TickerSymbol );
        System.assertEquals( null, acct.StockClosePrice__c );
        System.assertEquals( null, acct.StockLastRefreshedDate__c );

        Test.stopTest();

    }

    /**
     * Example of a process builder test.
     * When DML occurs, the process executes.
     * Like testing Apex code, we need to assert our declarative side effects too.
     */
    @IsTest
    static void whenRatingChangesThenPostToChatter() {

        List<FeedItem> posts;

        Account acct = new Account(
            Name = 'Test Account'
        );

        insert acct;

        System.assertEquals( 0, [ SELECT COUNT() FROM FeedItem WHERE ParentId = :acct.Id ] );

        Test.startTest();

        // assert 'Hot' => chatter post about hot
        acct.Rating = 'Hot';
        update acct;

        posts = [ SELECT Id, ParentId, Body FROM FeedItem WHERE ParentId = :acct.Id ];
        System.assertEquals( 1, posts.size() );
        System.assert( posts[0].Body.containsIgnoreCase( 'so hot' ) );
        delete posts;

        // assert 'Cold' => chatter post about cold
        acct.Rating = 'Cold';
        update acct;

        posts = [ SELECT Id, ParentId, Body FROM FeedItem WHERE ParentId = :acct.Id ];
        System.assertEquals( 1, posts.size() );
        System.assert( posts[0].Body.containsIgnoreCase( 'so cold' ) );
        delete posts;

        // assert 'Warm' => no chatter post
        acct.Rating = 'Warm';
        update acct;

        posts = [ SELECT Id, ParentId, Body FROM FeedItem WHERE ParentId = :acct.Id ];
        System.assertEquals( 0, posts.size() );

        Test.stopTest();

    }

}
