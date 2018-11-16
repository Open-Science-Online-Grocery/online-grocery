import { combineReducers } from 'redux';
import cart from './cart/cart-reducer';
import category from './category/category-reducer';
import user from './user/user-reducer';
import sorting from './sorting/sorting-reducer';
import search from './search/search-reducer';

const reducer = combineReducers({
  sorting,
  search,
  cart,
  category,
  user
});

export default reducer;
