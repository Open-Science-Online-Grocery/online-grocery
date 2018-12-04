import { connect } from 'react-redux';
import ProductFilter from './product-filter';
import { filteringActionCreators } from '../../reducers/filtering/filtering-actions';

const mapStateToProps = state => (
  {
    filterByTags: state.filtering.filterByTags,
    selectedFilterId: state.filtering.selectedFilterId,
    selectedFilterType: state.filtering.selectedFilterType,
    tags: state.category.tags,
    subtags: state.category.subtags.filter(subtag => subtag.name)
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleFilterChange: (selectedFilterId, selectedFilterType) => {
      dispatch(
        filteringActionCreators.updateFilter(
          selectedFilterId,
          selectedFilterType
        )
      );
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(ProductFilter);
