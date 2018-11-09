import { cartActionTypes } from './cart-actions'

const initialCartState = {count: 0, items:[], price: 0}

export default function cartReducer(state = initialCartState, action) {
    switch(action.type) {

        case(cartActionTypes.ADD_TO_CART):
            const itemAlreadyInCart = state.items.findIndex((item) => {
                return item.name == action.product.name
            })
            if (itemAlreadyInCart > -1) {
                const updatedItem =  Object.assign({}, state.items[itemAlreadyInCart], {
                    quantity: state.items[itemAlreadyInCart].quantity + action.product.quantity
                })
                let finalState = Object.assign({},state, {
                    count: state.count + action.product.quantity,
                    price: state.price + action.product.price * action.product.quantity
                })
                finalState.items[itemAlreadyInCart] = updatedItem
                return finalState
            }
            return Object.assign({},state, {
                count: state.count + action.product.quantity,
                items: [
                    ...state.items,
                    action.product
                ],
                price: state.price + action.product.price * action.product.quantity
            })

        case(cartActionTypes.REMOVE_FROM_CART):
            const productIndex = state.items.indexOf(action.product)
            const newitems = Object.assign([], state.items)
            if (productIndex > -1) {
                newitems.splice(productIndex, 1)
            }
            return Object.assign({}, state, {
                count: state.count - action.product.quantity,
                items: newitems,
                price: state.price - action.product.price * action.product.quantity
            })

        case(cartActionTypes.CLEAR_CART):
            return initialCartState

        default:
            return state
    }
}
