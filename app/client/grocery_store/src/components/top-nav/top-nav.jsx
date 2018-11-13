import React from 'react';
import PropTypes from 'prop-types';
import Tab from '../tab/tab';
import Search from '../search/search';
import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';
import './top-nav.scss';

export default class TopNav extends React.Component {
  componentDidMount() {
    this.getInitialProducts();
  }

  getInitialProducts() {
    fromApi.jsonApiCall(
      routes.categoryProducts(),
      { conditionIdentifier: this.props.conditionIdentifier },
      data => this.props.handleSetProducts(data),
      error => console.log(error)
    );
  }

  render() {
    const subcats = Object.assign([], this.props.subcategories);
    const tabs = this.props.categories.map((tab) => {
      const tabSubcats = [];
      while (subcats.length > 0 && subcats[0].categoryId === tab.id) {
        tabSubcats.push(subcats.shift());
      }
      return (
        <Tab
          tabName={tab.name}
          key={tab.id}
          index={tab.id}
          subcats={tabSubcats}
          category={this.props.category}
          conditionIdentifier={this.props.conditionIdentifier}
          handleSetCategory={this.props.handleSetCategory}
          handleSetProducts={this.props.handleSetProducts}
        />
      );
    });
    return (
      <div>
        <div className="top-nav">
          {tabs}
        </div>
        <Search
          handleSetProducts={this.props.handleSetProducts}
          conditionIdentifier={this.props.conditionIdentifier}
        />
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
  conditionIdentifier: PropTypes.string.isRequired,
  handleSetProducts: PropTypes.func.isRequired,
  handleSetCategory: PropTypes.func.isRequired
};

TopNav.defaultProps = {
  category: null
};
