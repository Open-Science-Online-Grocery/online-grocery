import React from 'react';
import PropTypes from 'prop-types';
import Tab from '../tab/tab';
import SearchContainer from '../search/search-container';
import './top-nav.scss';

// eslint-disable-next-line react/prefer-stateless-function
export default class TopNav extends React.Component {
  constructor(props) {
    super(props);
    this.categoryTabs = this.categoryTabs.bind(this);
    this.tagTab = this.tagTab.bind(this);
    this.categoryTitle = this.categoryTitle.bind(this);
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
    const {
      selectedCategoryId,
      selectedCategoryType,
      categories,
      subcategories
    } = this.props;
    return categories.map((tabCategory, index) => {
      const tabSubcats = subcategories.filter(subcat => (
        subcat.categoryId === tabCategory.id
      ));
      return (
        <Tab
          tabName={tabCategory.name}
          key={`category-${tabCategory.id}`}
          categoryId={tabCategory.id}
          categoryType="category"
          subcats={tabSubcats}
          selectedCategoryId={selectedCategoryId}
          selectedCategoryType={selectedCategoryType}
          flyoutDirection={this.flyoutDirection(index)}
        />
      );
    });
  }

  tagTab() {
    const {
      selectedCategoryId,
      selectedCategoryType,
      displayedTag,
      subtags
    } = this.props;

    if (displayedTag) {
      const subtagsForTab = subtags.filter(subtag => (
        subtag.name && subtag.tagId === displayedTag.id
      ));
      return (
        <Tab
          tabName={displayedTag.name}
          key={`tag-${displayedTag.id}`}
          categoryId={displayedTag.id}
          categoryType="tag"
          subcats={subtagsForTab}
          selectedCategoryId={selectedCategoryId}
          selectedCategoryType={selectedCategoryType}
          flyoutDirection="left" // always flyout left since it's the rightmost tab on the screen
        />
      );
    }
    return null;
  }

  categoryTitle() {
    const {
      selectedCategoryId,
      selectedCategoryType,
      categories,
      tags
    } = this.props;
    switch (selectedCategoryType) {
      case 'tag':
        return tags.find(tag => tag.id === selectedCategoryId).name;
      case 'category':
        return categories.find(category => category.id === selectedCategoryId).name;
      default:
        return null;
    }
  }

  render() {
    return (
      <div>
        <div className="top-nav">
          {this.categoryTabs()}
          {this.tagTab()}
        </div>
        <SearchContainer />
        <div className="title">
          {this.categoryTitle()}
        </div>
      </div>
    );
  }
}

TopNav.propTypes = {
  selectedCategoryId: PropTypes.number,
  selectedCategoryType: PropTypes.string,
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
  subcategories: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string
    })
  ).isRequired,
  tags: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string
    })
  ).isRequired,
  subtags: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string
    })
  ).isRequired
};

TopNav.defaultProps = {
  selectedCategoryId: null,
  selectedCategoryType: null,
  displayedTag: null
};
