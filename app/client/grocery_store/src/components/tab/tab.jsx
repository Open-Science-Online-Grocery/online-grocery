import React from 'react';
import PropTypes from 'prop-types';
import SubtabContainer from '../subtab/subtab-container';
import './tab.scss';

export default class Tab extends React.Component {
  constructor(props) {
    super(props);
    this.state = { open: false };
    this.openDropdown = this.openDropdown.bind(this);
    this.closeDropdown = this.closeDropdown.bind(this);
  }

  openDropdown() {
    this.setState({ open: true });
  }

  closeDropdown() {
    this.setState({ open: false });
  }

  buildSubcategories() {
    return this.props.subcats.map(subcat => (
      <SubtabContainer
        key={subcat.id}
        subcat={subcat}
        categoryId={this.props.categoryId}
        categoryType={this.props.categoryType}
        flyoutDirection={this.props.flyoutDirection}
      />
    ));
  }

  render() {
    return (
      <div
        className={this.props.isSelected ? 'tab-container selected' : 'tab-container'}
        onMouseEnter={this.openDropdown}
        onMouseLeave={this.closeDropdown}
      >
        <div className="tab">
          <div>{this.props.tabName}</div>
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
  categoryId: PropTypes.number.isRequired,
  categoryType: PropTypes.string.isRequired,
  subcats: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number,
      name: PropTypes.string,
      categoryId: PropTypes.number
    })
  ).isRequired,
  isSelected: PropTypes.bool.isRequired,
  flyoutDirection: PropTypes.string.isRequired
};
