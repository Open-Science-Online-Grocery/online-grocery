import React from 'react';
import PropTypes from 'prop-types';
import './product-filter.scss';

export default class ProductFilter extends React.Component {
  constructor(props) {
    super(props);
    this.onSelectChange = this.onSelectChange.bind(this);
  }

  onSelectChange(event) {
    const selectedValue = event.target.value;
    this.props.handleFilterChange(selectedValue);
  }

  selectOptions() {
    const blankOption = (<option value="" key="0">None</option>);
    const subtagOptions = this.props.subtags.map(
      subtag => (
        <option
          value={subtag.id}
          key={subtag.id}
        >
          {subtag.name}
        </option>
      )
    );
    subtagOptions.unshift(blankOption);
    return subtagOptions;
  }

  render() {
    if (!this.props.filterByTags) { return null; }
    return (
      <div className="product-filter-container">
        <label htmlFor="product-filter-select">Filter by:</label>
        <select
          id="product-filter-select"
          onChange={this.onSelectChange}
        >
          {this.selectOptions()}
        </select>
      </div>
    );
  }
}

ProductFilter.propTypes = {
  filterByTags: PropTypes.bool,
  subtags: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number,
      tagId: PropTypes.number,
      name: PropTypes.string
    })
  ).isRequired,
  handleFilterChange: PropTypes.func.isRequired
};

ProductFilter.defaultProps = {
  filterByTags: false
};
