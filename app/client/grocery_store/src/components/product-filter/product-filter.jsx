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
    const [filterType, filterId] = selectedValue.split('_');
    this.props.handleFilterChange(parseInt(filterId, 10), filterType);
  }

  tagOption(tag) {
    return (
      <option value={`tag_${tag.id}`} key={tag.id}>
        {tag.name}
      </option>
    );
  }

  subtagOption(subtag) {
    const parentTag = this.props.tags.find(tag => tag.id === subtag.tagId);
    return (
      <option value={`subtag_${subtag.id}`} key={subtag.id}>
        {`${parentTag.name}: ${subtag.name}`}
      </option>
    );
  }

  selectOptions() {
    const blankOption = (<option value="" key="0">None</option>);
    const tagOptions = this.props.tags.map(tag => this.tagOption(tag));
    const subtagOptions = this.props.subtags.map(subtag => this.subtagOption(subtag));
    return [blankOption].concat(tagOptions).concat(subtagOptions);
  }

  render() {
    if (!this.props.filterByTags) { return null; }
    return (
      <div className="product-filter-container">
        <label htmlFor="product-filter-select">Filter by:</label>
        <select
          id="product-filter-select"
          onChange={this.onSelectChange}
          value={`${this.props.selectedFilterType}_${this.props.selectedFilterId}`}
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
  tags: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number,
      name: PropTypes.string
    })
  ).isRequired,
  selectedFilterId: PropTypes.number,
  selectedFilterType: PropTypes.string, // should be "tag" or "subtag"
  handleFilterChange: PropTypes.func.isRequired
};

ProductFilter.defaultProps = {
  filterByTags: false,
  selectedFilterId: null,
  selectedFilterType: null
};
