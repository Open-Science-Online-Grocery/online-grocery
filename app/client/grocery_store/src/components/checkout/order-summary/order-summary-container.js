import React from 'react'
import OrderSummary from './order-summary'
import { connect } from 'react-redux'
import { cartActionCreators } from '../../../reducers/cart/cart-actions';
import axios from 'axios';

const mapStateToProps = function(state){
    return {
        cart: state.cart,
        sessionID: state.user.sessionID
    }
}

const mapDispatchToProps = function (dispatch) {
    return {
        handleRemoveFromCart: (product) => {
            dispatch(cartActionCreators.removeFromCart(product))
        },
        handleClearCart: () => {
            dispatch(cartActionCreators.clearCart())
        }
    }
}

class OrderSummaryContainer extends React.Component {
    render() {
        return (
            <OrderSummary {...this.props} />
        )
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderSummaryContainer)
