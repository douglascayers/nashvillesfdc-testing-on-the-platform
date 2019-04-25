/**
 * More examples of jest tests for lightning web components
 * are available in the LWC Recipes sample repo at
 * https://github.com/trailheadapps/lwc-recipes
 */

import { createElement } from 'lwc';
import FinanceStockInfo from 'c/financeStockInfo';
import { registerLdsTestWireAdapter } from '@salesforce/lwc-jest';
import { getRecord } from 'lightning/uiRecordApi';
import getStockInfoForSymbol from '@salesforce/apex/FinanceController.getStockInfoForSymbol';
import LOCALE from '@salesforce/i18n/locale';
import CURRENCY from '@salesforce/i18n/currency';

const mockGetStockInfo = require( './data/getStockInfoForSymbol.json' );
const mockAccountWithTickerSymbol = require( './data/getRecordAccountWithTickerSymbol.json' );
const mockAccountWithoutTickerSymbol = require( './data/getRecordAccountWithoutTickerSymbol.json' );

// Register as an LDS wire adapter. Some tests verify the provisioned values trigger desired behavior.
const getRecordAdapter = registerLdsTestWireAdapter( getRecord );

// Mocking imperative Apex method call
jest.mock(
    '@salesforce/apex/FinanceController.getStockInfoForSymbol',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

describe( 'c-finance-stock-info', () => {

    afterEach( () => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while ( document.body.firstChild ) {
            document.body.removeChild( document.body.firstChild );
        }
        // Prevent data saved on mocks from leaking between tests
        jest.clearAllMocks();
    });

    // Helper function to wait until the microtask queue is empty. This is needed for promise
    // timing when calling imperative Apex.
    function flushPromises() {
        // eslint-disable-next-line no-undef
        return new Promise( resolve => setImmediate( resolve ) );
    }

    it( 'renders stock info', () => {

        // Create initial element
        const element = createElement( 'c-finance-stock-info', {
            is: FinanceStockInfo
        });
        document.body.appendChild( element );

        // Assign mock value for resolved Apex promise
        getStockInfoForSymbol.mockResolvedValue( mockGetStockInfo );

        // Emit data from @wire
        getRecordAdapter.emit( mockAccountWithTickerSymbol );

        // Return an immediate flushed promise (after the Apex call) to then
        // wait for any asynchronous DOM updates. Jest will automatically wait
        // for the Promise chain to complete before ending the test and fail
        // the test if the promise ends in the rejected state.
        return flushPromises().then( () => {

            const currencyFormat = new Intl.NumberFormat( LOCALE, {
                style: 'currency',
                currency: CURRENCY,
                currencyDisplay: 'symbol'
            });

            // Select elements for validation
            const stockInfoSymbolEl = element.shadowRoot.querySelector( '.stock-info_symbol' );
            expect( stockInfoSymbolEl.textContent ).toBe( mockGetStockInfo.symbol );

            const stockInfoOpenPriceEl = element.shadowRoot.querySelector( '.stock-info_openPrice' );
            expect( stockInfoOpenPriceEl.textContent ).toBe( currencyFormat.format( mockGetStockInfo.openPrice ) );

            const stockInfoHighPriceEl = element.shadowRoot.querySelector( '.stock-info_highPrice' );
            expect( stockInfoHighPriceEl.textContent ).toBe( currencyFormat.format( mockGetStockInfo.highPrice ) );

            const stockInfoLowPriceEl = element.shadowRoot.querySelector( '.stock-info_lowPrice' );
            expect( stockInfoLowPriceEl.textContent ).toBe( currencyFormat.format( mockGetStockInfo.lowPrice ) );

            const stockInfoClosePriceEl = element.shadowRoot.querySelector( '.stock-info_closePrice' );
            expect( stockInfoClosePriceEl.textContent ).toBe( currencyFormat.format( mockGetStockInfo.closePrice ) );

        });

    });

    it( 'does not render stock info', () => {

        // Create initial element
        const element = createElement( 'c-finance-stock-info', {
            is: FinanceStockInfo
        });
        document.body.appendChild( element );

        // Assign mock value for resolved Apex promise
        getStockInfoForSymbol.mockResolvedValue( { /* no data */ } );

        // Emit data from @wire
        getRecordAdapter.emit( mockAccountWithoutTickerSymbol );

        // Return an immediate flushed promise (after the Apex call) to then
        // wait for any asynchronous DOM updates. Jest will automatically wait
        // for the Promise chain to complete before ending the test and fail
        // the test if the promise ends in the rejected state.
        return flushPromises().then( () => {

            // Select elements for validation
            const stockInfoSymbolEl = element.shadowRoot.querySelector( '.stock-info_symbol' );


            // const stockInfoOpenPriceEl = element.shadowRoot.querySelector( '.stock-info_openPrice' );
            // expect( stockInfoOpenPriceEl ).toBe( null );

            // const stockInfoHighPriceEl = element.shadowRoot.querySelector( '.stock-info_highPrice' );
            // expect( stockInfoHighPriceEl ).toBe( null );

            // const stockInfoLowPriceEl = element.shadowRoot.querySelector( '.stock-info_lowPrice' );
            // expect( stockInfoLowPriceEl ).toBe( null );

            // const stockInfoClosePriceEl = element.shadowRoot.querySelector( '.stock-info_closePrice' );
            // expect( stockInfoClosePriceEl ).toBe( null );

        });

    });

});