import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';
import './tab.scss';

export default class Tab extends React.Component {
  constructor(props) {
    super(props);
    this.state = { open: false };
    this.openDropdown = this.openDropdown.bind(this);
    this.closeDropdown = this.closeDropdown.bind(this);
    this.handleTabClick = this.getProducts.bind(this);
  }

  getProducts(subcat) {
    const categoryParams = {
      conditionIdentifier: this.props.conditionIdentifier,
      category: this.props.index,
      subcategory: subcat.display_order
    };
    axios.get('/api/category', { params: categoryParams })
      .then((res) => {
        console.log(res.data);
        this.props.handleSetProducts(res.data);
      })
      .catch(err => console.log(err));
    this.props.handleSetCategory(this.props.index, subcat.category_id);
  }

  openDropdown() {
    this.setState({ open: true });
  }

  closeDropdown() {
    this.setState({ open: false });
  }

  buildSubcategories() {
    return this.props.subcats.map((subcat, key) => (
      <div className="tab-subcat-bar" key={key} onClick={() => this.handleTabClick(subcat)}>
        <div className="tab-subcat-title" key={key}>
          {subcat.name}
        </div>
      </div>
    ));
  }

  render() {
    return (
      <div
        className={this.props.index === this.props.category ? 'tab-container selected' : 'tab-container'}
        onMouseEnter={() => this.openDropdown()}
        onMouseLeave={() => this.closeDropdown()}
      >
        <div className="tab">
          {this.props.tabName}
        </div>
        {
          this.state.open
            && (
              <div className="tab-dropdown">
                {this.buildSubcategories()}
              </div>
            )
         }
      </div>
    );
  }
}

Tab.propTypes = {
  tabName: PropTypes.string.isRequired,
  index: PropTypes.number.isRequired,
  subcats: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string
    })
  ).isRequired,
  category: PropTypes.number.isRequired,
  conditionIdentifier: PropTypes.string.isRequired,
  handleSetCategory: PropTypes.func.isRequired,
  handleSetProducts: PropTypes.func.isRequired
};
