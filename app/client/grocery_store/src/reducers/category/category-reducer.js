import { categoryActionTypes } from './category-actions'

const initialCategoryState = { category: 1, subcategory: 1, products: [], categories: [], subcategories: []}

export default function categoryReducer(state = initialCategoryState, action) {
    switch (action.type) {

        case(categoryActionTypes.SET_CATEGORY):
            return Object.assign({}, state, {
                category: action.category,
                subcategory: action.subcategory
            })

        case(categoryActionTypes.SET_PRODUCTS):
            return Object.assign({}, state, {
                products: action.products
            })

        case(categoryActionTypes.SET_CATEGORIES):
            return Object.assign({}, state, {
                categories: action.categories
            })

        case(categoryActionTypes.SET_SUBCATEGORIES):
            return Object.assign({}, state, {
                subcategories: action.subcategories
            })


        default:
            return state
    }
}
