import { connect } from 'react-redux';
import SortLinks from './sort-links';
import { sortingActionCreators } from '../../reducers/sorting/sorting-actions';

const mapStateToProps = state => (
  {
    sortFields: state.sorting.sortFields,
    selectedSortField: state.sorting.selectedSortField,
    sortDirection: state.sorting.sortDirection
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleClick: (selectedSortField, sortDirection) => {
      dispatch(sortingActionCreators.updateSorting(selectedSortField, sortDirection));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(SortLinks);
