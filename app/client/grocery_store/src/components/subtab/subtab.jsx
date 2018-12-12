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
                  this.props.categoryType
                )
              )
            }
          >
            {this.props.subcat.name}
          </div>


          {
            this.state.open && (
              <div className="tab-subsubcat-list">
                <div className="tab-subsubcat">
                  foo
                </div>
                <div className="tab-subsubcat">
                  bar
                </div>
                <div className="tab-subsubcat">
                  baz
                </div>
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
  handleSetCategory: PropTypes.func.isRequired
};
