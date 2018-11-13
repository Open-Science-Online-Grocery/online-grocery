import { connect } from 'react-redux';
import Search from './search';
import { searchActionCreators } from '../../reducers/search/search-actions';

const mapDispatchToProps = dispatch => (
  {
    handleSubmit: (searchTerm) => {
      dispatch(searchActionCreators.updateSearchTerm(searchTerm));
    }
  }
);

export default connect(null, mapDispatchToProps)(Search);
