import { combineReducers } from 'redux';
import cart from './cart/cart-reducer';
import category from './category/category-reducer';
import user from './user/user-reducer';
import sorting from './sorting/sorting-reducer';

const reducer = combineReducers({
  sorting,
  cart,
  category,
  user
});

export default reducer;
