import { connect } from 'react-redux';
import OnlineGrocery from './online-grocery';
import { searchActionCreators } from './reducers/search/search-actions';

const mapStateToProps = (state) => (
  { loaderActive: state.category.loaderActive }
);

const mapDispatchToProps = (dispatch) => (
  {
    updateSearchType: () => {
      dispatch(searchActionCreators.updateSearchType('category'));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(OnlineGrocery);
