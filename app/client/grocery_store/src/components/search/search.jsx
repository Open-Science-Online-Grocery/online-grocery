import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import SortLinksContainer from '../sort-links/sort-links-container';
import './search.scss';

class Search extends React.Component {
  constructor(props) {
    super(props);
    this.state = { value: '' };
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({ value: event.target.value });
  }

  handleSubmit(event) {
    event.preventDefault();
    this.props.handleSubmit(this.state.value);
    this.props.history.push({ pathname: '/store/search' });
  }

  render() {
    return (
      <div className="search-container">
        <SortLinksContainer />
        <form onSubmit={this.handleSubmit}>
          <input
            className="form-input"
            type="text"
            placeholder="Search..."
            value={this.state.value}
            onChange={this.handleChange}
          />
          {/* html entity below is a unicode magnifying glass icon */}
          <button type="submit">&#128270;</button>
        </form>
      </div>
    );
  }
}

Search.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  history: PropTypes.object.isRequired
};

export default withRouter(Search);
