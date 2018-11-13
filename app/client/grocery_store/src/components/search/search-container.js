import { connect } from 'react-redux';
import Search from './search';
import { searchActionCreators } from '../../reducers/search/search-actions';

const mapStateToProps = state => (
  {
    search: state.search
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleSubmit: (search) => {
      dispatch(searchActionCreators.updateSearch(search));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(Search);
