import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';
import Tab from '../tab/tab';
import './top-nav.scss';
import Search from '../search/search';

export default class TopNav extends React.Component {
  componentDidMount() {
    this.getInitialData();
  }

  getInitialData() {
    const categoryParams = {
      conditionIdentifier: this.props.conditionIdentifier,
      category: 1,
      subcategory: 1
    };
    axios.get('/api/category', { params: categoryParams })
      .then(res => this.props.handleSetProducts(res.data))
      .catch(err => console.log(err));
    axios.get('/api/categories')
      .then(res => this.props.handleSetCategories(res.data))
      .catch(err => console.log(err));
    axios.get('/api/subcategories')
      .then(res => this.props.handleSetSubcategories(res.data))
      .catch(err => console.log(err));
  }

  render() {
    const subcats = Object.assign([], this.props.subcategories);
    const tabs = this.props.categories.map((tab) => {
      const tabSubcats = [];
      while (subcats.length > 0 && subcats[0].category_id === tab.id) {
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
        <Search handleSetProducts={this.props.handleSetProducts} />
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
  category: PropTypes.number.isRequired,
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
  handleSetCategories: PropTypes.func.isRequired,
  handleSetSubcategories: PropTypes.func.isRequired,
  handleSetCategory: PropTypes.func.isRequired
};
