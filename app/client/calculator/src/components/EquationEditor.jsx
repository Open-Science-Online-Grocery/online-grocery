import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';

const RIGHT = 39;
const LEFT = 37;
const BACKSPACE = 8;

export default class EquationEditor extends PureComponent {
  componentDidMount() {
    document.addEventListener('keydown', this.handleKeydown.bind(this), false);
  }

  componentWillUnmount() {
    document.removeEventListener('keydown', this.handleKeydown.bind(this), false);
  }

  handleKeydown(event) {
    if (event.keyCode === RIGHT) return this.props.moveCursor(true);
    if (event.keyCode === LEFT) return this.props.moveCursor(false);
    if (event.keyCode === BACKSPACE) return this.props.deletePreviousToken();
  }

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
      <div className="equation-editor">
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
  cursorPosition: PropTypes.number.isRequired,
  moveCursor: PropTypes.func.isRequired,
  deletePreviousToken: PropTypes.func.isRequired
};
