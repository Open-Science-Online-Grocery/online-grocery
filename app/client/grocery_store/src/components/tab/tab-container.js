import { connect } from 'react-redux';
import { tabIsSelected } from '../../reducers/reducer';
import Tab from './tab';

const mapStateToProps = (state, ownProps) => {
  // TODO: subcats
  return {
    subcats: [],
    showSubtabs: state.user.showProductsBySubcategory,
    isSelected: tabIsSelected(state, ownProps.categoryType, ownProps.categoryId)
  };
};

export default connect(mapStateToProps)(Tab);
