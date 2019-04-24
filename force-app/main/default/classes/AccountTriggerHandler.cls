public with sharing class AccountTriggerHandler {

    // -------------------------------------------------------
    // INSERT
    // -------------------------------------------------------

    public void handleBeforeInsert( List<Account> newList ) {

        // no logic yet

    }

    public void handleAfterInsert( List<Account> newList, Map<ID, Account> newMap ) {

        // no logic yet

    }

    // -------------------------------------------------------
    // UPDATE
    // -------------------------------------------------------

    public void handleBeforeUpdate( List<Account> oldList, Map<ID, Account> oldMap,
                                    List<Account> newList, Map<ID, Account> newMap ) {

        for ( Account newAccount : newList ) {

            Account oldAccount = oldMap.get( newAccount.Id );

            Boolean tickerSymbolChanged = ( oldAccount.TickerSymbol != newAccount.TickerSymbol );

            if ( tickerSymbolChanged ) {
                clearStockFields( newAccount );
            }

        }

    }

    public void handleAfterUpdate( List<Account> oldList, Map<ID, Account> oldMap,
                                   List<Account> newList, Map<ID, Account> newMap ) {

        // no logic yet

    }

    // -------------------------------------------------------
    // DELETE
    // -------------------------------------------------------

    public void handleBeforeDelete( List<Account> oldList, Map<ID, Account> oldMap ) {

        // no logic yet

    }

    public void handleAfterDelete( List<Account> oldList, Map<ID, Account> oldMap ) {

        // no logic yet

    }

    // -------------------------------------------------------

    public static void clearStockFields( Account acct ) {
        acct.StockClosePrice__c = null;
        acct.StockLastRefreshedDate__c = null;
    }

}
