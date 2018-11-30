import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';
import { alertActionCreators } from '../alert/alert-actions';
import BudgetManager from '../../utils/BudgetManager';

export const cartActionTypes = {
  ADD_TO_CART: 'ADD_TO_CART',
  REMOVE_FROM_CART: 'REMOVE_FROM_CART',
  CLEAR_CART: 'CLEAR_CART',
  SET_CART_SETTINGS: 'SET_CART_SETTINGS'
};

function getBudgetManager(state) {
  return new BudgetManager(
    state.cart.price,
    state.cart.maximumSpend,
    state.cart.minimumSpend
  );
}

function overMaxSpend(state) {
  const budgetManager = getBudgetManager(state);
  return budgetManager.overMaxSpend();
}

function underMinSpend(state) {
  const budgetManager = getBudgetManager(state);
  return budgetManager.underMinSpend();
}

function addToCart(product, quantity = 1) {
  return (dispatch, getState) => {
    const overMaxSpendBefore = overMaxSpend(getState());

    const newProduct = Object.assign({}, product, { quantity });
    dispatch({ type: cartActionTypes.ADD_TO_CART, product: newProduct });

    const overMaxSpendAfter = overMaxSpend(getState());

    if (!overMaxSpendBefore && overMaxSpendAfter) {
      dispatch(alertActionCreators.showAlert(
        'Your cart is now over your maximum budget.'
      ));
    }
  };
}

function removeFromCart(product) {
  return (dispatch, getState) => {
    const underMinSpendBefore = underMinSpend(getState());
    dispatch({ type: cartActionTypes.REMOVE_FROM_CART, product });

    const underMinSpendAfter = underMinSpend(getState());

    if (!underMinSpendBefore && underMinSpendAfter) {
      dispatch(alertActionCreators.showAlert(
        'Your cart is now under your minimum budget.'
      ));
    }
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
  return {
    type: cartActionTypes.SET_CART_SETTINGS,
    ...cartSettings
  };
}

export const cartActionCreators = {
  addToCart,
  removeFromCart,
  clearCart,
  getCartSettings
};
