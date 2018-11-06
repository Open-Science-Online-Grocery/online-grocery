import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';

export default class EquationEditor extends PureComponent {
  cursor() {
    return (
      <div key="cursor" className="cursor">|</div>
    );
  }

  tokensWithCursor() {
    const tokens = this.props.tokens.map(
      token => (
        <div key={token.id} className={`token ${token.type}`}>
          {token.name || token.value}
        </div>
      )
    );
    tokens.splice(this.props.cursorPosition, 0, this.cursor());
    return tokens;
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
      id: PropTypes.string.isRequired,
      type: PropTypes.string.isRequired,
      value: PropTypes.string.isRequired,
      name: PropTypes.string
    })
  ).isRequired,
  cursorPosition: PropTypes.number.isRequired
};
