import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';

export const cartActionTypes = {
  ADD_TO_CART: 'ADD_TO_CART',
  REMOVE_FROM_CART: 'REMOVE_FROM_CART',
  CLEAR_CART: 'CLEAR_CART',
  SET_CART_SETTINGS: 'SET_CART_SETTINGS'
};

function addToCart(product, quantity = 1) {
  const newProduct = Object.assign({}, product, {
    quantity
  });
  return {
    type: cartActionTypes.ADD_TO_CART,
    product: newProduct
  };
}

function removeFromCart(product) {
  return {
    type: cartActionTypes.REMOVE_FROM_CART,
    product
  };
}

function clearCart() {
  return {
    type: cartActionTypes.CLEAR_CART
  };
}

function getCartSettings() {
  return (dispatch, getState) => {
    const state = getState();
    const params = {
      conditionIdentifier: state.user.conditionIdentifier,
      cartProducts: state.cart.items.map(item => (
        { id: item.id, quantity: item.quantity, hasLabel: !!item.labelImageUrl }
      ))
    };
    fromApi.jsonApiCall(
      routes.cartSettings(),
      params,
      data => dispatch(setCartSettings(data)),
      error => console.log(error)
    );
  };
}

function setCartSettings(cartSettings) {
  console.log(cartSettings)
  // return {
  //   type: cartActionTypes.SET_CART_SETTINGS,
  //   cartSettings
  // };
}

export const cartActionCreators = {
  addToCart,
  removeFromCart,
  clearCart,
  getCartSettings
};
