public inherited sharing class FinanceService {

    // The AlphaVantage API key should be in custom metadata or custom setting
    private static final String API_KEY = 'Q1GONL4ZQSJ59T64';

    public StockInfo getStockInfoForSymbol( String symbol ) {

        String apiFunction = 'TIME_SERIES_DAILY';

        HttpRequest req = new HttpRequest();
        req.setMethod( 'GET' );
        req.setEndpoint(
            String.format(
                'https://www.alphavantage.co/query?function={0}&symbol={1}&apikey={2}',
                new String[] {
                    EncodingUtil.urlEncode( apiFunction, 'UTF-8' ),
                    EncodingUtil.urlEncode( symbol, 'UTF-8' ),
                    EncodingUtil.urlEncode( API_KEY, 'UTF-8' )
                }
            )
        );
        req.setHeader( 'Content-Type', 'application/json' );
        req.setHeader( 'Accepts', 'application/json' );
        req.setCompressed( true );

        System.debug( req );
        System.debug( req.getBody() );

        HttpResponse res = new Http().send( req );

        System.debug( res );
        System.debug( res.getBody() );

        if ( res.getStatus() == 'OK' ) {

            // I would have loved to use https://github.com/open-force/jsonparse
            // but the JSON keys in the response from AlphaVantage are ridiculous
            Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped( res.getBody() );

            Map<String, Object> metaDataMap = (Map<String, Object>) jsonMap.get( 'Meta Data' );
            String lastRefreshedDate = ( (String) metaDataMap.get( '3. Last Refreshed' ) ).left( 10 );

            Map<String, Object> dailyTimeSeriesMap = (Map<String, Object>) jsonMap.get( 'Time Series (Daily)' );
            Map<String, Object> dayStockInfoMap = (Map<String, Object>) dailyTimeSeriesMap.get( lastRefreshedDate );
            Decimal openPrice  = Decimal.valueOf( (String) dayStockInfoMap.get( '1. open' ) );
            Decimal highPrice  = Decimal.valueOf( (String) dayStockInfoMap.get( '2. high' ) );
            Decimal lowPrice   = Decimal.valueOf( (String) dayStockInfoMap.get( '3. low' ) );
            Decimal closePrice = Decimal.valueOf( (String) dayStockInfoMap.get( '4. close' ) );

            StockInfo info = new StockInfo();
            info.lastRefreshedDate = Date.valueOf( lastRefreshedDate );
            info.symbol = symbol;
            info.openPrice = openPrice;
            info.highPrice = highPrice;
            info.lowPrice = lowPrice;
            info.closePrice = closePrice;

            return info;

        } else {

            throw new FinanceException( 'Error getting stock info for symbol: ' + symbol );

        }

    }

    public class StockInfo {

        @AuraEnabled
        public Date lastRefreshedDate { get; set; }

        @AuraEnabled
        public String symbol { get; set; }

        @AuraEnabled
        public Decimal openPrice { get; set; }

        @AuraEnabled
        public Decimal highPrice { get; set; }

        @AuraEnabled
        public Decimal lowPrice { get; set; }

        @AuraEnabled
        public Decimal closePrice { get; set; }

    }

    public class FinanceException extends Exception {}

}
