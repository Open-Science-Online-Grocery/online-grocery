import { connect } from 'react-redux';
import OnlineGrocery from './online-grocery';
import { searchActionCreators } from './reducers/search/search-actions';

const mapDispatchToProps = dispatch => (
  {
    resetSearch: () => {
      dispatch(searchActionCreators.updateSearch(null));
    }
  }
);

export default connect(null, mapDispatchToProps)(OnlineGrocery);
