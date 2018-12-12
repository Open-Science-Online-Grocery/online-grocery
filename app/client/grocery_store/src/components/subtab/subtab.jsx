import React from 'react';
import PropTypes from 'prop-types';

export default class Subtab extends React.Component {
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

  buildSubsubcategories() {
    return this.props.subsubcats.map(subsubcat => (
      <div
        key={subsubcat.id}
        className="tab-subsubcat"
        onClick={
          () => (
            this.props.handleSetCategory(
              this.props.subcat.categoryId,
              this.props.subcat.id,
              subsubcat.id,
              this.props.categoryType
            )
          )
        }
      >
        {subsubcat.name}
      </div>
    ));
  }

  render() {
    return (
      <div
        className="tab-subcat-bar"
        onMouseEnter={this.openDropdown}
        onMouseLeave={this.closeDropdown}
      >
        <div className="tab-subcat-item">
          <div
            className="tab-subcat-title"
            onClick={
              () => (
                this.props.handleSetCategory(
                  this.props.subcat.categoryId,
                  this.props.subcat.id,
                  null,
                  this.props.categoryType
                )
              )
            }
          >
            {this.props.subcat.name}
          </div>
          {
            this.state.open && (
              <div className={`tab-subsubcat-list flyout-${this.props.flyoutDirection}`}>
                {this.buildSubsubcategories()}
              </div>
            )
          }
        </div>
      </div>
    );
  }
}

Subtab.propTypes = {
  categoryType: PropTypes.string.isRequired,
  subcat: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
    categoryId: PropTypes.number
  }).isRequired,
  subsubcats: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string
    })
  ).isRequired,
  flyoutDirection: PropTypes.string.isRequired,
  handleSetCategory: PropTypes.func.isRequired
};
