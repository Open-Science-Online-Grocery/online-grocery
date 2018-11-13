import React from 'react';
import PropTypes from 'prop-types';
import Tab from '../tab/tab';
import SearchContainer from '../search/search-container';
import './top-nav.scss';

export default class TopNav extends React.Component {
  render() {
    const subcats = Object.assign([], this.props.subcategories);
    const tabs = this.props.categories.map((category) => {
      const tabSubcats = [];
      while (subcats.length > 0 && subcats[0].categoryId === category.id) {
        tabSubcats.push(subcats.shift());
      }
      return (
        <Tab
          tabName={category.name}
          key={category.id}
          id={category.id}
          subcats={tabSubcats}
          category={this.props.category}
          handleSetCategory={this.props.handleSetCategory}
        />
      );
    });
    return (
      <div>
        <div className="top-nav">
          {tabs}
        </div>
        <SearchContainer />
        {
          this.props.categories[this.props.category - 1]
            && (
              <div className="title">
                {this.props.categories[this.props.category - 1].name}
              </div>
            )
        }
      </div>
    );
  }
}

TopNav.propTypes = {
  category: PropTypes.number,
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
  handleSetCategory: PropTypes.func.isRequired
};

TopNav.defaultProps = {
  category: null
};
