import { connect } from 'react-redux';
import SearchPage from './search-page';
import { searchActionCreators } from './reducers/search/search-actions';

const mapStateToProps = state => (
  {
    searchTerm: state.search.term
  }
);

const mapDispatchToProps = dispatch => (
  {
    updateSearchType: () => {
      dispatch(searchActionCreators.updateSearchType('term'));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(SearchPage);
