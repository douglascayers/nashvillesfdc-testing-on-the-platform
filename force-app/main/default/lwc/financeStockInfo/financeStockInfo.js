import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import getStockInfoForSymbol from '@salesforce/apex/FinanceController.getStockInfoForSymbol';

const ACCOUNT_FIELDS = [ 'Account.TickerSymbol' ];

export default class FinanceStockInfo extends LightningElement {

    @api recordId;

    @track stockInfo;

    @wire( getRecord, { recordId: '$recordId', fields: ACCOUNT_FIELDS } )
    wiredRecord( { error, data } ) {
        if ( error ) {
            this.handleError( error );
        } else if ( data ) {
            const tickerSymbol = data.fields.TickerSymbol.value;
            getStockInfoForSymbol({ symbol: tickerSymbol }).then( result => {
                this.stockInfo = result;
            });
        }
    }

    handleError( error ) {
        let message = 'Unknown error';
        if ( Array.isArray( error.body ) ) {
            message = error.body.map( e => e.message ).join( ', ' );
        } else if ( typeof error.body.message === 'string' ) {
            message = error.body.message;
        }
        this.dispatchEvent(
            new ShowToastEvent( {
                title: 'Error loading account',
                message,
                variant: 'error',
            } ),
        );
    }

}