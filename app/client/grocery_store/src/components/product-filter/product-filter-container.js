import { connect } from 'react-redux';
import ProductFilter from './product-filter';
import { filteringActionCreators } from '../../reducers/filtering/filtering-actions';

const mapStateToProps = state => (
  {
    filterByTags: state.sorting.filterByTags,
    subtags: state.category.subtags
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleFilterChange: (selectedFilterId) => {
      dispatch(filteringActionCreators.updateFilter(selectedFilterId));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(ProductFilter);
