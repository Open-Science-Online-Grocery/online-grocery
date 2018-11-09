import React from 'react'
import { Route } from 'react-router-dom'
import OrderSummaryContainer from './components/checkout/order-summary/order-summary-container'
import './checkout-page.scss'
var path = require('path')

export default class CheckoutPage extends React.Component {
    render() {
        return(
            <div>
                <img className='logo-style' src={`${path.join(__dirname, 'images/howesgrocerybanner.png')}`}/>
                <div className='checkout-title'>Checkout</div>
                <Route render={({history}) => (
                    <form onSubmit={() => {
                        history.push('/thank-you')
                    }}
                          className='checkout-sections'>
                        <OrderSummaryContainer/>
                    </form>
                )}>
                </Route>
            </div>
        )
    }
}
