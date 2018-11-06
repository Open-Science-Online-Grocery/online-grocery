import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { Icon, Message } from 'semantic-ui-react';

export default class TestResults extends PureComponent {
  className() {
    return this.props.valid ? 'positive' : 'negative';
  }

  iconName() {
    return this.props.valid ? 'check' : 'exclamation triangle';
  }

  header() {
    return `This calculation is ${this.props.valid ? 'valid' : 'invalid'}`;
  }

  render() {
    if (typeof this.props.valid !== 'boolean') return null;
    return (
      <div>
        <Message icon className={this.className()}>
          <Icon name={this.iconName()} />
          <Message.Content>
            <Message.Header>
              {this.header()}
            </Message.Header>
            {this.props.validationMessage}
          </Message.Content>
        </Message>
      </div>
    );
  }
}

TestResults.propTypes = {
  valid: PropTypes.bool,
  validationMessage: PropTypes.string
};

TestResults.defaultProps = {
  valid: null,
  validationMessage: null
};
