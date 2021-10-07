import { connect } from 'react-redux';
import { getCategoryTitle } from '../../reducers/reducer';
import TopNav from './top-nav';

const mapStateToProps = (state) => {
  const { categories, tags } = state.category;
  // TODO: Change this if they want to choose which tag gets displayed as a tab
  const firstTag = tags.length > 0 ? Object.values(tags)[0] : null;
  return ({
    displayedTag: firstTag,
    categories,
    tags,
    categoryTitle: getCategoryTitle(state)
  });
};

export default connect(mapStateToProps)(TopNav);
