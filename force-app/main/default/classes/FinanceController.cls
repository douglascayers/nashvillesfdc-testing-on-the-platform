public with sharing class FinanceController {

    @AuraEnabled( cacheable = true )
    public static FinanceService.StockInfo getStockInfoForSymbol( String symbol ) {
        if ( String.isBlank( symbol ) ) { return null; }
        return new FinanceService().getStockInfoForSymbol( symbol );
    }

}
