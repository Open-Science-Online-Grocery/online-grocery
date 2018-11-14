import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import './session-id-page.scss';

class SessionIDPage extends React.Component {
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
    if (this.state.value !== '') {
      this.props.handleSessionIdSubmitted(this.state.value);
      this.props.history.push({
        pathname: '/store/home'
      });
    }
  }

  render() {
    const staticText = 'Please enter your session ID given to you by Qualtrics:';
    return (
      <div className="form-container session-id-page">
        <form className="form-style" onSubmit={this.handleSubmit}>
          <div className="form-prompt">{staticText}</div>
          <input className="form-input" type="text" value={this.state.value} onChange={this.handleChange} />
          <input type="submit" value="Submit" />
        </form>
      </div>
    );
  }
}

SessionIDPage.propTypes = {
  history: PropTypes.object.isRequired,
  handleSessionIdSubmitted: PropTypes.func.isRequired
};

export default withRouter(SessionIDPage);
