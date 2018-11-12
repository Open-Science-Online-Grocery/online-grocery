import React from 'react'
import ProductCardExpanded from './product-card-expanded'
import { connect } from 'react-redux'
import { cartActionCreators } from '../../reducers/cart/cart-actions';

const mapDispatchToProps = function (dispatch) {
    return {
        handleAddToCart: (product, quantity) => {
            dispatch(cartActionCreators.addToCart(product, quantity))
        }
    }
}

const mapStateToProps = function(state){
    return {
        sessionId: state.user.sessionId,
        conditionIdentifier: state.user.conditionIdentifier
    }
}

class ProductCardContainer extends React.Component {
    render() {
        return (
            <ProductCardExpanded {...this.props} />
        )
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(ProductCardContainer)
