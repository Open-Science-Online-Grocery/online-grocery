import { connect } from 'react-redux';
import OrderSummary from './order-summary';
import { cartActionCreators } from '../../../reducers/cart/cart-actions';
import { userActionCreators } from '../../../reducers/user/user-actions';
import BudgetManager from '../../../utils/BudgetManager';

const mapStateToProps = (state) => {
  const budgetManager = new BudgetManager(
    state.cart.price,
    state.cart.maximumSpend,
    state.cart.minimumSpend
  );
  return {
    cart: state.cart,
    subtotal: budgetManager.subtotal(),
    tax: budgetManager.tax(),
    total: budgetManager.total(),
    errorMessage: budgetManager.checkoutErrorMessage()
  };
};

const mapDispatchToProps = dispatch => (
  {
    handleRemoveFromCart: (product) => {
      dispatch(cartActionCreators.removeFromCart(product));
    },
    handleClearCart: () => {
      dispatch(cartActionCreators.clearCart());
    },
    getCartSettings: () => {
      dispatch(cartActionCreators.getCartSettings());
    },
    logParticipantAction: (actionType, productId, quantity) => {
      dispatch(
        userActionCreators.logParticipantAction(actionType, productId, quantity)
      );
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(OrderSummary);
