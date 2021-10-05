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

  tabBody() {
    const { tabName, clickable, handleSetCategory } = this.props;
    if (clickable) {
      return (
        <div className="clickable tab" onClick={handleSetCategory}>
          <div>{tabName}</div>
        </div>
      );
    }
    return (
      <div className="tab">
        <div>{tabName}</div>
      </div>
    );
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
    const { isSelected, subcats } = this.props;
    return (
      <div
        className={isSelected ? 'tab-container selected' : 'tab-container'}
        onMouseEnter={this.openDropdown}
        onMouseLeave={this.closeDropdown}
      >
        {this.tabBody()}
        {
          subcats.length
            && this.state.open
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
  clickable: PropTypes.bool.isRequired,
  flyoutDirection: PropTypes.string.isRequired,
  handleSetCategory: PropTypes.func.isRequired
};
