import { connect } from 'react-redux';
import OnlineGrocery from './online-grocery';
import { searchActionCreators } from './reducers/search/search-actions';

const mapDispatchToProps = (dispatch) => (
  {
    updateSearchType: () => {
      dispatch(searchActionCreators.updateSearchType('category'));
    }
  }
);

export default connect(null, mapDispatchToProps)(OnlineGrocery);
