import { connect } from 'react-redux';
import { getCategoryTitle } from '../../reducers/reducer';
import TopNav from './top-nav';

const mapStateToProps = (state) => {
  const { categories, tags } = state.category;
  // TODO: Change this if they want to choose which tag gets displayed as a tab
  return ({
    categories,
    tags,
    categoryTitle: getCategoryTitle(state),
    allowSearching: state.user.allowSearching
  });
};

export default connect(mapStateToProps)(TopNav);
