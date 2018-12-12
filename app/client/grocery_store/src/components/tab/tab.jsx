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
        categoryType={this.props.categoryType}
      />
    ));
  }

  render() {
    return (
      <div
        className={
          this.props.categoryId === this.props.selectedCategoryId
          && this.props.categoryType === this.props.selectedCategoryType
            ? 'tab-container selected' : 'tab-container'
        }
        onMouseEnter={this.openDropdown}
        onMouseLeave={this.closeDropdown}
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
  categoryId: PropTypes.number.isRequired,
  categoryType: PropTypes.string.isRequired,
  subcats: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string
    })
  ).isRequired,
  selectedCategoryId: PropTypes.number,
  selectedCategoryType: PropTypes.string // should be 'category' or 'tag'
};

Tab.defaultProps = {
  selectedCategoryId: null,
  selectedCategoryType: null
};
