import React from 'react'
import OnlineGrocery from './online-grocery'
import { connect } from 'react-redux'
import { categoryActionCreators } from './reducers/category/category-actions';

const mapStateToProps = function(state){
    return {
        category: state.category.category,
        categories: state.category.categories,
        subcategories: state.category.subcategories
    }
}

const mapDispatchToProps = function (dispatch) {
    return {
        handleSetCategory: (category, subcategory) => {
            dispatch(categoryActionCreators.setCategory(category, subcategory))
        },
        handleSetProducts: (products) => {
            dispatch(categoryActionCreators.setProducts(products))
        },
        handleSetCategories: (categories) => {
            dispatch(categoryActionCreators.setCategories(categories))
        },
        handleSetSubcategories: (subcategories) => {
            dispatch(categoryActionCreators.setSubcategories(subcategories))
        }
    }
}

class OnlineGroceryContainer extends React.Component {
    render() {
        return (
            <OnlineGrocery {...this.props} />
        )
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(OnlineGroceryContainer)

