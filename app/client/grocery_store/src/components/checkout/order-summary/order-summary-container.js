import { connect } from 'react-redux';
import OrderSummary from './order-summary';
import { cartActionCreators } from '../../../reducers/cart/cart-actions';
import { userActionCreators } from '../../../reducers/user/user-actions';
import BudgetManager from '../../../utils/BudgetManager';
import { getCustomAttributeTotal } from '../../../reducers/reducer';

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
    budgetErrorMessage: budgetManager.checkoutErrorMessage(),
    checkoutErrorMessage: state.cart.checkoutErrorMessage,
    displayCustomAttrOnCheckout: state.user.displayCustomAttrOnCheckout,
    customAttrName: state.user.customAttrName,
    customAttrUnit: state.user.customAttrUnit,
    customAttributeTotal: getCustomAttributeTotal(state),
    checkoutProcessing: state.cart.checkoutProcessing
  };
};

const mapDispatchToProps = (dispatch, ownProps) => (
  {
    handleRemoveFromCart: (product) => {
      dispatch(cartActionCreators.removeFromCart(product));
    },
    handleCheckout: () => {
      dispatch(userActionCreators.checkout(ownProps.onSubmit));
    },
    getCartSettings: () => {
      dispatch(cartActionCreators.getCartSettings());
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(OrderSummary);
