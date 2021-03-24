import { combineReducers } from 'redux';
import cart from './cart/cart-reducer';
import category from './category/category-reducer';
import user from './user/user-reducer';
import sorting from './sorting/sorting-reducer';
import search from './search/search-reducer';
import alert from './alert/alert-reducer';
import suggestion from './suggestion/suggestion-reducer';
import filtering from './filtering/filtering-reducer';
import { userActionTypes } from './user/user-actions';

const appReducer = combineReducers({
  sorting,
  search,
  cart,
  category,
  user,
  alert,
  suggestion,
  filtering
});

// reset approach adapted from https://stackoverflow.com/a/35641992/10410128
const rootReducer = (state, action) => {
  if (action.type === userActionTypes.RESET_ALL) {
    return appReducer(undefined, action);
  }
  return appReducer(state, action);
};

export default rootReducer;
