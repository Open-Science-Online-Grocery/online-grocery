import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';
import { withRouter } from 'react-router-dom';
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
    axios.get('/api/product_search', {params: {search: this.state.value}})
      .then((res) => {
        this.props.handleSetProducts(res.data);
        this.props.history.push({ pathname: '/store/search' });
      })
      .catch(err => console.log(err));
  }

  render() {
    return (
      <div className="search-container">
        <form onSubmit={this.handleSubmit}>
          <button type="submit">&#128270;</button>
          <input
            className="form-input"
            type="text"
            placeholder="Search..."
            value={this.state.value}
            onChange={this.handleChange}
          />
        </form>
      </div>
    );
  }
}

Search.propTypes = {
  handleSetProducts: PropTypes.func.isRequired,
  history: PropTypes.object.isRequired
};

export default withRouter(Search);
