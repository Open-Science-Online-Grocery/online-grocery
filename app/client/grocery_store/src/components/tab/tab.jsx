import React from 'react';
import PropTypes from 'prop-types';
import './tab.scss';
import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';

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
      subcategory: subcat.displayOrder
    };
    fromApi.jsonApiCall(
      routes.categoryProducts(),
      categoryParams,
      data => this.props.handleSetProducts(data),
      error => console.log(error)
    );
    this.props.handleSetCategory(this.props.index, subcat.categoryId);
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
  category: PropTypes.number,
  conditionIdentifier: PropTypes.string.isRequired,
  handleSetCategory: PropTypes.func.isRequired,
  handleSetProducts: PropTypes.func.isRequired
};

Tab.defaultProps = {
  category: null
};
