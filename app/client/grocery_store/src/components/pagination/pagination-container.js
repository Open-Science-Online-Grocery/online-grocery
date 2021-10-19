import { connect } from 'react-redux';
import Pagination from './pagination';

const mapStateToProps = state => (
  {
    currentPage: 3,
    totalPages: 12
  }
);

export default connect(mapStateToProps, null)(Pagination);
