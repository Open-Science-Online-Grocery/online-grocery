import React from 'react'
import SearchPage from './search-page'
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
        }
    }
}


class SearchPageContainer extends React.Component {
    render() {
        return (
            <SearchPage {...this.props} />
        )
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(SearchPageContainer)
