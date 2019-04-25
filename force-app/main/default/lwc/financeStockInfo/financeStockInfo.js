import { LightningElement, track, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getStockInfoForSymbol from '@salesforce/apex/FinanceController.getStockInfoForSymbol';

const ACCOUNT_FIELDS = [ 'Account.TickerSymbol' ];

export default class FinanceStockInfo extends LightningElement {

    @api recordId;

    @track symbol;

    @track stockInfo;

    @wire( getRecord, { recordId: '$recordId', fields: ACCOUNT_FIELDS } )
    wiredRecord( { error, data } ) {
        this.symbol = null;
        this.stockInfo = null;
        if ( error ) {
            this.handleError( error );
        } else if ( data ) {
            const tickerSymbol = data.fields.TickerSymbol.value;
            this.symbol = tickerSymbol;
        }
    }

    @wire( getStockInfoForSymbol, { symbol : '$symbol' } )
    wiredStockInfo( { error, data } ) {
        this.stockInfo = null;
        if ( error ) {
            this.handleError( error );
        } else if ( data ) {
            this.stockInfo = data;
        }
    }

    handleError( error ) {
        // eslint-disable-next-line no-console
        console.error( error );
    }

}