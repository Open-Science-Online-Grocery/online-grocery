import React from 'react';
import PropTypes from 'prop-types';
import Tab from '../tab/tab';
import SearchContainer from '../search/search-container';
import './top-nav.scss';

// eslint-disable-next-line react/prefer-stateless-function
export default class TopNav extends React.Component {
  render() {
    const {
      category,
      tag,
      categories,
      subcategories,
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
          key={tabCategory.id}
          id={tabCategory.id}
          subcats={tabSubcats}
          category={category}
          handleSetCategory={handleSetCategory}
        />
      );
    });

    const tagTab = () => {
      if (tag) {
        const subtagsForTab = subtags.filter(subtag => subtag.tagId === tag.id);
        return (
          <Tab
            tabName={tag.name}
            key={tag.id}
            id={tag.id}
            subcats={subtagsForTab}
            category={tag.id} // TODO: Allow Tab to accept Tags as Categories
            handleSetCategory={handleSetCategory} // TODO: Make one for tag
          />
        );
      }
      return null;
    };

    return (
      <div>
        <div className="top-nav">
          {categoryTabs}
          {tagTab()}
        </div>
        <SearchContainer />
        {
          categories[category - 1]
            && (
              <div className="title">
                {categories[category - 1].name}
              </div>
            )
        }
      </div>
    );
  }
}

TopNav.propTypes = {
  category: PropTypes.number,
  tag: PropTypes.shape({
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
  category: null,
  tag: null
};
