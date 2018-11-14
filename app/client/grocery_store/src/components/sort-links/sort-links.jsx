import React from 'react';
import PropTypes from 'prop-types';
import './sort-links.scss';

export default class SortLinks extends React.Component {
  nextSortDirecton(selected) {
    if (!selected) return 'asc';
    return this.props.sortDirection === 'desc' ? 'asc' : 'desc';
  }

  sortButton(fieldName) {
    const selected = fieldName === this.props.selectedSortField;
    const nextSortDirecton = this.nextSortDirecton(selected);
    const onClick = () => this.props.handleClick(fieldName, nextSortDirecton);
    return (
      <button
        key={fieldName}
        className={selected ? 'sort-link active' : 'sort-link'}
        type="button"
        onClick={onClick}
      >
        <span className="sort-field">
          {fieldName}
        </span>
        <span className="sort-arrow">
          {this.props.sortDirection === 'desc' ? ' ▼' : ' ▲'}
        </span>
      </button>
    );
  }

  render() {
    if (!this.props.sortFields.length) return <div />;
    return (
      <div className="sort-links">
        <span className="sort-label">Sort by:</span>
        {this.props.sortFields.map(fieldName => this.sortButton(fieldName))}
      </div>
    );
  }
}

SortLinks.propTypes = {
  sortFields: PropTypes.arrayOf(PropTypes.string).isRequired,
  selectedSortField: PropTypes.string,
  sortDirection: PropTypes.string,
  handleClick: PropTypes.func.isRequired
};

SortLinks.defaultProps = {
  selectedSortField: null,
  sortDirection: null
};
