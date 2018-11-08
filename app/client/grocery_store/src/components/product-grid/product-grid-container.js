import React from 'react'
import ProductGrid from './product-grid'
import { connect } from 'react-redux'

const mapStateToProps = function(state){
    return {
        sessionID: state.user.sessionID,
        products: state.category.products
    }
}

class ProductGridContainer extends React.Component {
    render() {
        console.log(this.props)
        return (
            <ProductGrid {...this.props} />
        )
    }
}

export default connect(mapStateToProps, null)(ProductGridContainer)