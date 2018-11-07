import React from 'react'
import ProductCard from './product-card'
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
        sessionID: state.user.sessionID
    }
}

class ProductCardContainer extends React.Component {
    render() {
        return (
            <ProductCard {...this.props} />
        )
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(ProductCardContainer)
