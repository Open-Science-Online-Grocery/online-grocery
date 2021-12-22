import { cartActionTypes } from './cart-actions';
import { userActionTypes } from '../user/user-actions';

const initialCartState = {
  count: 0,
  price: 0,
  showPriceTotal: true,
  items: [],
  healthLabelSummaries: [],
  labelImageUrls: [],
  checkoutProcessing: false,
  checkoutErrorMessage: null
};

// An index of -1 indicates that the item is not in the cart
const getItemIndexInCart = (item, itemsInCart) => (
  itemsInCart.findIndex(itemInCart => itemInCart.name === item.name)
);

export default function cartReducer(state = initialCartState, action) {
  switch (action.type) {
    case userActionTypes.SET_CONDITION_DATA:
      return Object.assign({}, state, {
        showPriceTotal: action.showPriceTotal,
        minimumSpend: action.minimumSpend,
        maximumSpend: action.maximumSpend
      });
    case cartActionTypes.ADD_TO_CART: {
      const itemIndexInCart = getItemIndexInCart(action.product, state.items);

      if (itemIndexInCart > -1) {
        const updatedItem = Object.assign({}, state.items[itemIndexInCart], {
          quantity: state.items[itemIndexInCart].quantity + action.product.quantity
        });
        const finalState = Object.assign({}, state, {
          count: state.count + action.product.quantity,
          price: state.price + action.product.price * action.product.quantity
        });
        finalState.items[itemIndexInCart] = updatedItem;
        return finalState;
      }
      return Object.assign({}, state, {
        count: state.count + action.product.quantity,
        items: [
          ...state.items,
          action.product
        ],
        price: state.price + action.product.price * action.product.quantity
      });
    }
    case cartActionTypes.REMOVE_FROM_CART: {
      const productIndex = state.items.indexOf(action.product);
      const newItems = Object.assign([], state.items);

      if (productIndex > -1) {
        newItems.splice(productIndex, 1);
      }
      return Object.assign({}, state, {
        count: state.count - action.product.quantity,
        items: newItems,
        price: state.price - action.product.price * action.product.quantity
      });
    }
    case cartActionTypes.SET_CART_SETTINGS: {
      const { healthLabelSummaries, labelImageUrls } = action;
      return Object.assign({}, state, { healthLabelSummaries, labelImageUrls });
    }
    case userActionTypes.START_CHECKOUT_PROCESSING: {
      return Object.assign({}, state, {
        checkoutProcessing: true,
        checkoutErrorMessage: null
      });
    }
    case userActionTypes.CHECKOUT_FAILURE: {
      return Object.assign({}, state, {
        checkoutProcessing: false,
        checkoutErrorMessage: action.message
      });
    }
    case (cartActionTypes.CLEAR_CART):
      return Object.assign({}, state, {
        count: 0,
        price: 0,
        items: [],
        healthLabelSummaries: [],
        labelImageUrls: []
      });
    default:
      return state;
  }
}
