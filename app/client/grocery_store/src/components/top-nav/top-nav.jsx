import React from 'react';
import PropTypes from 'prop-types';
import Tab from '../tab/tab';
import SearchContainer from '../search/search-container';
import './top-nav.scss';

// eslint-disable-next-line react/prefer-stateless-function
export default class TopNav extends React.Component {
  render() {
    const {
      selectedCategoryId,
      selectedCategoryType,
      displayedTag,
      categories,
      subcategories,
      tags,
      subtags,
      handleSetCategory
    } = this.props;
    const duplicatedSubcats = Object.assign([], subcategories);
    const categoryTabs = categories.map((tabCategory) => {
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

    const tagTab = () => {
      if (displayedTag) {
        const subtagsForTab = subtags.filter(subtag => subtag.tagId === displayedTag.id);
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
    };

    const categoryTitle = () => {
      if (selectedCategoryType === 'tag') {
        return tags[selectedCategoryId - 1].name;
      }
      return categories[selectedCategoryId - 1].name;
    };

    return (
      <div>
        <div className="top-nav">
          {categoryTabs}
          {tagTab()}
        </div>
        <SearchContainer />
        {
          categories[selectedCategoryId - 1]
            && (
              <div className="title">
                {categoryTitle()}
              </div>
            )
        }
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
