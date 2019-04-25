@IsTest
public inherited sharing class FinanceServiceHttpCalloutMock implements System.HttpCalloutMock {

    public HttpResponse respond( HttpRequest req ) {

        URL endpointUrl = new URL( req.getEndpoint() );

        HttpResponse res = new HttpResponse();

        // A way for tests to ask for different responses is for the mock class
        // to either provide class properties the test sets ahead of time, or,
        // as is done here, to look for specific URL values in the request endpoint.
        if ( endpointUrl.getQuery().containsIgnoreCase( 'symbol=CRM' ) ) {

            res.setStatus( 'OK' );
            res.setStatusCode( 200 );
            res.setBody( JSON.serializePretty( new Map<String, Object>{
                'Meta Data' => new Map<String, Object>{
                    '1. Information' => 'Daily Prices (open, high, low, close) and Volumes',
                    '2. Symbol' => 'CRM',
                    '3. Last Refreshed' => '2019-04-25 10:52:59'
                },
                'Time Series (Daily)' => new Map<String, Object>{
                    '2019-04-25' => new Map<String, Object>{
                         '1. open'  => '120.0000',
                         '2. high'  => '150.0000',
                         '3. low'   => '100.0000',
                         '4. close' => '130.0000'
                    }
                }
            }));

        }
        // For a test to ask for an error response, they use the ERROR ticker symbol.
        else if ( endpointUrl.getQuery().containsIgnoreCase( 'symbol=ERROR' ) ) {

            res.setStatus( 'Error' );
            res.setStatusCode( 500 );

        }

        return res;
    }

}
