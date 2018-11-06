import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';

export default class EquationEditor extends PureComponent {
  cursor() {
    return (
      <div className="cursor">|</div>
    );
  }

  tokensWithCursor() {
    const tokens = this.props.tokens.map(
      token => (
        <div className={`token ${token.type}`}>{token.name || token.value}</div>
      )
    );
    return tokens.splice(this.props.cursorPosition, 0, this.cursor());
  }

  render() {
    return (
      <div>
        <div className="ui segment">
          {this.tokensWithCursor()}
        </div>
      </div>
    );
  }
}

EquationEditor.propTypes = {
  tokens: PropTypes.arrayOf(
    PropTypes.shape({
      type: PropTypes.string.isRequired,
      value: PropTypes.string.isRequired,
      name: PropTypes.string
    })
  ).isRequired,
  cursorPosition: PropTypes.number.isRequired
};
