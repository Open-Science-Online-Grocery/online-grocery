import { combineReducers } from 'redux';
import cart from './cart/cart-reducer';
import category from './category/category-reducer';
import user from './user/user-reducer';
import sorting from './sorting/sorting-reducer';
import search from './search/search-reducer';
import { userActionTypes } from './user/user-actions';

const appReducer = combineReducers({
  sorting,
  search,
  cart,
  category,
  user
});

// reset approach adapted from https://stackoverflow.com/a/35641992/10410128
const rootReducer = (state, action) => {
  if (action.type === userActionTypes.RESET_ALL) {
    return appReducer(undefined, action);
  }
  return appReducer(state, action);
};

export default rootReducer;
