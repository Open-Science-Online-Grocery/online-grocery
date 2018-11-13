import { connect } from 'react-redux';
import SearchPage from './search-page';

const mapStateToProps = state => (
  {
    search: state.search
  }
);

export default connect(mapStateToProps)(SearchPage);
