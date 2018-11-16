import React from 'react'
import CartDropdown from './cart-dropdown'
import { connect } from 'react-redux'
import { cartActionCreators } from '../../reducers/cart/cart-actions';

const mapStateToProps = function(state){
    return {
        cart: state.cart,
        sessionId: state.user.sessionId,
        conditionIdentifier: state.user.conditionIdentifier
    }
}

const mapDispatchToProps = function (dispatch) {
    return {
        handleRemoveFromCart: (product) => {
            dispatch(cartActionCreators.removeFromCart(product))
        }
    }
}

class CartDropdownContainer extends React.Component {
    render() {
        return (
            <CartDropdown {...this.props} />
        )
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(CartDropdownContainer)
