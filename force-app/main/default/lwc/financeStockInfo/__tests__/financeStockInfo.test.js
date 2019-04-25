/**
 * More examples of jest tests for lightning web components
 * are available in the LWC Recipes sample repo at
 * https://github.com/trailheadapps/lwc-recipes
 */

import { createElement } from 'lwc';
import FinanceStockInfo from 'c/financeStockInfo';
import { registerLdsTestWireAdapter, registerApexTestWireAdapter } from '@salesforce/lwc-jest';
import { getRecord } from 'lightning/uiRecordApi';
import getStockInfoForSymbol from '@salesforce/apex/FinanceController.getStockInfoForSymbol';

const mockGetStockInfo = require( './data/getStockInfoForSymbol.json' );
const mockAccountWithTickerSymbol = require( './data/getRecordAccountWithTickerSymbol.json' );
const mockAccountWithoutTickerSymbol = require( './data/getRecordAccountWithoutTickerSymbol.json' );

// Register as an LDS wire adapter. Some tests verify the provisioned values trigger desired behavior.
const getRecordAdapter = registerLdsTestWireAdapter( getRecord );

// Register as Apex wire adapter. Some tests verify that provisioned values trigger desired behavior.
const getStockInfoAdapter = registerApexTestWireAdapter( getStockInfoForSymbol );

describe( 'c-finance-stock-info', () => {

    afterEach( () => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while ( document.body.firstChild ) {
            document.body.removeChild( document.body.firstChild );
        }
        // Prevent data saved on mocks from leaking between tests
        jest.clearAllMocks();
    });

    it( 'renders stock info', () => {

        // Create initial element
        const element = createElement( 'c-finance-stock-info', {
            is: FinanceStockInfo
        });
        document.body.appendChild( element );

        // Emit data from @wire
        getRecordAdapter.emit( mockAccountWithTickerSymbol );

        // Emit data from @wire
        getStockInfoAdapter.emit( mockGetStockInfo );

        // Return an immediate flushed promise (after the Apex call) to then
        // wait for any asynchronous DOM updates. Jest will automatically wait
        // for the Promise chain to complete before ending the test and fail
        // the test if the promise ends in the rejected state.
        return Promise.resolve().then( () => {

            // Select elements for validation
            const stockInfoSymbolEl = element.shadowRoot.querySelector( '.stock-info_symbol' );
            expect( stockInfoSymbolEl.textContent ).toBe( mockGetStockInfo.symbol );

            const stockInfoOpenPriceEl = element.shadowRoot.querySelector( '.stock-info_openPrice lightning-formatted-number' );
            expect( stockInfoOpenPriceEl.value ).toBe( mockGetStockInfo.openPrice );

            const stockInfoHighPriceEl = element.shadowRoot.querySelector( '.stock-info_highPrice lightning-formatted-number' );
            expect( stockInfoHighPriceEl.value ).toBe( mockGetStockInfo.highPrice );

            const stockInfoLowPriceEl = element.shadowRoot.querySelector( '.stock-info_lowPrice lightning-formatted-number' );
            expect( stockInfoLowPriceEl.value ).toBe( mockGetStockInfo.lowPrice );

            const stockInfoClosePriceEl = element.shadowRoot.querySelector( '.stock-info_closePrice lightning-formatted-number' );
            expect( stockInfoClosePriceEl.value ).toBe( mockGetStockInfo.closePrice );

        });

    });

    it( 'it does not render stock info', () => {

        // Create initial element
        const element = createElement( 'c-finance-stock-info', {
            is: FinanceStockInfo
        });
        document.body.appendChild( element );

        // Emit data from @wire
        getRecordAdapter.emit( mockAccountWithTickerSymbol );

        getStockInfoAdapter.emit( null );

        // Return an immediate flushed promise (after the Apex call) to then
        // wait for any asynchronous DOM updates. Jest will automatically wait
        // for the Promise chain to complete before ending the test and fail
        // the test if the promise ends in the rejected state.
        return Promise.resolve().then( () => {

            // Select elements for validation
            const stockInfoSymbolEl = element.shadowRoot.querySelector( '.stock-info_symbol' );
            expect( stockInfoSymbolEl ).toBeNull();

            const stockInfoOpenPriceEl = element.shadowRoot.querySelector( '.stock-info_openPrice lightning-formatted-number' );
            expect( stockInfoOpenPriceEl ).toBeNull();

            const stockInfoHighPriceEl = element.shadowRoot.querySelector( '.stock-info_highPrice lightning-formatted-number' );
            expect( stockInfoHighPriceEl ).toBeNull();

            const stockInfoLowPriceEl = element.shadowRoot.querySelector( '.stock-info_lowPrice lightning-formatted-number' );
            expect( stockInfoLowPriceEl ).toBeNull();

            const stockInfoClosePriceEl = element.shadowRoot.querySelector( '.stock-info_closePrice lightning-formatted-number' );
            expect( stockInfoClosePriceEl ).toBeNull();

        });

    });

});