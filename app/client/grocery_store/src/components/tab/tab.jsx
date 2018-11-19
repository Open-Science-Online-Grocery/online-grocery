import React from 'react';
import PropTypes from 'prop-types';
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
      <div
        className="tab-subcat-bar"
        key={subcat.id}
        onClick={() => this.props.handleSetCategory(this.props.id, subcat.id)}
      >
        <div className="tab-subcat-title">
          {subcat.name}
        </div>
      </div>
    ));
  }

  render() {
    return (
      <div
        className={this.props.id === this.props.category ? 'tab-container selected' : 'tab-container'}
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
  id: PropTypes.number.isRequired,
  subcats: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string
    })
  ).isRequired,
  category: PropTypes.number,
  handleSetCategory: PropTypes.func.isRequired
};

Tab.defaultProps = {
  category: null
};
