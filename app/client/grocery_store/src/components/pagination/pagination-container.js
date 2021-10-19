import { connect } from 'react-redux';
import Pagination from './pagination';
import { categoryActionCreators } from '../../reducers/category/category-actions';

const mapStateToProps = state => (
  {
    currentPage: parseInt(state.category.page, 10),
    totalPages: parseInt(state.category.totalPages, 10)
  }
);

const mapDispatchToProps = dispatch => (
  {
    requestPage: (requestedPage) => (
      dispatch(categoryActionCreators.getProducts(requestedPage))
    )
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(Pagination);
