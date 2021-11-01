import React from 'react';
import PropTypes from 'prop-types';
import TabContainer from '../tab/tab-container';
import SearchContainer from '../search/search-container';
import './top-nav.scss';

// eslint-disable-next-line react/prefer-stateless-function
export default class TopNav extends React.Component {
  constructor(props) {
    super(props);
    this.categoryTabs = this.categoryTabs.bind(this);
    this.tagTab = this.tagTab.bind(this);
  }

  // this determines which side the sub-sub-category flyout menus should
  // appear on based on the tab's position on the screen, which we calculate
  // based on the tab's index in the list of tabs to render. if the tab is on
  // the left 50% of the screen, the flyout menu should appear on the right,
  // else on the left.
  flyoutDirection(tabIndex) {
    let tabCount = this.props.categories.length;
    if (this.props.displayedTag) tabCount += 1;
    return (tabIndex / tabCount < 0.5) ? 'right' : 'left';
  }

  categoryTabs() {
    const { categories } = this.props;
    return categories.map((tabCategory, index) => {
      return (
        <TabContainer
          tabName={tabCategory.name}
          key={`category-${tabCategory.id}`}
          categoryId={tabCategory.id}
          categoryType="category"
          flyoutDirection={this.flyoutDirection(index)}
        />
      );
    });
  }

  tagTab() {
    const { displayedTag } = this.props;
    if (displayedTag) {
      return (
        <TabContainer
          tabName={displayedTag.name}
          key={`tag-${displayedTag.id}`}
          categoryId={displayedTag.id}
          categoryType="tag"
          flyoutDirection="left" // always flyout left since it's the rightmost tab on the screen
        />
      );
    }
    return null;
  }

  render() {
    const { categoryTitle, allowSearching } = this.props;
    return (
      <div className="top-nav">
        <div className="menu">
          {this.categoryTabs()}
          {this.tagTab()}
        </div>
        {allowSearching && <SearchContainer />}
        <div className="title">
          {categoryTitle}
        </div>
      </div>
    );
  }
}

TopNav.propTypes = {
  displayedTag: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string
  }),
  categories: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string,
      id: PropTypes.number
    })
  ).isRequired,
  tags: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string
    })
  ).isRequired,
  categoryTitle: PropTypes.string,
  allowSearching: PropTypes.bool.isRequired
};

TopNav.defaultProps = {
  displayedTag: null,
  categoryTitle: ''
};
