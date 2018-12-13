import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';
import { alertActionCreators } from '../alert/alert-actions';
import { userActionCreators } from '../user/user-actions';
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

function dollarsToQuantity(product, amount) {
  return Math.floor(amount / product.price);
}

function addToCart(product, amount, addByDollar) {
  return (dispatch, getState) => {
    const overMaxSpendBefore = overMaxSpend(getState());

    const quantity = addByDollar ? dollarsToQuantity(product, amount) : amount;
    const newProduct = Object.assign({}, product, { quantity });
    dispatch({ type: cartActionTypes.ADD_TO_CART, product: newProduct });
    dispatch(
      userActionCreators.logParticipantAction(
        'add',
        newProduct.id,
        quantity
      )
    );

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

function setCartSettings(cartSettings) {
  return {
    type: cartActionTypes.SET_CART_SETTINGS,
    ...cartSettings
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

export const cartActionCreators = {
  addToCart,
  removeFromCart,
  clearCart,
  getCartSettings
};
