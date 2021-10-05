import { connect } from 'react-redux';
import Tab from './tab';

const mapStateToProps = (state, ownProps) => {
  // TODO: subcats
  return {
    showSubtabs: state.user.showProductsBySubcategory
  };
};

export default connect(mapStateToProps)(Tab);
