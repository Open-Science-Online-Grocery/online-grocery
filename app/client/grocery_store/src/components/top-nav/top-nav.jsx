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

  categoryTabs() {
    const {
      selectedCategoryId,
      selectedCategoryType,
      categories,
      subcategories,
      handleSetCategory
    } = this.props;
    const duplicatedSubcats = Object.assign([], subcategories);

    return categories.map((tabCategory) => {
      const tabSubcats = [];
      while (duplicatedSubcats.length > 0 && duplicatedSubcats[0].categoryId === tabCategory.id) {
        tabSubcats.push(duplicatedSubcats.shift());
      }
      return (
        <Tab
          tabName={tabCategory.name}
          key={`category-${tabCategory.id}`}
          categoryId={tabCategory.id}
          categoryType="category"
          subcats={tabSubcats}
          selectedCategoryId={selectedCategoryId}
          selectedCategoryType={selectedCategoryType}
          handleSetCategory={handleSetCategory}
        />
      );
    });
  }

  tagTab() {
    const {
      selectedCategoryId,
      selectedCategoryType,
      displayedTag,
      subtags,
      handleSetCategory
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
          handleSetCategory={handleSetCategory}
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
  ).isRequired,
  handleSetCategory: PropTypes.func.isRequired
};

TopNav.defaultProps = {
  selectedCategoryId: null,
  selectedCategoryType: null,
  displayedTag: null
};
