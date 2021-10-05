import { connect } from 'react-redux';
import Tab from './tab';
import { tabIsSelected, subtabs } from '../../reducers/reducer';
import { categoryActionCreators } from '../../reducers/category/category-actions';

const mapStateToProps = (state, ownProps) => {
  let subcats = [];
  if (state.user.showProductsBySubcategory) {
    subcats = subtabs(state, ownProps.categoryType, ownProps.categoryId);
  }
  return {
    subcats,
    clickable: !subcats.length,
    isSelected: tabIsSelected(state, ownProps.categoryType, ownProps.categoryId)
  };
};

const mapDispatchToProps = (dispatch, ownProps) => (
  {
    handleSetCategory: () => {
      dispatch(
        categoryActionCreators.updateCategory(
          ownProps.categoryId,
          null,
          null,
          ownProps.categoryType
        )
      );
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(Tab);
