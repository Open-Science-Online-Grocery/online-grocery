import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';

const RIGHT = 39;
const LEFT = 37;
const BACKSPACE = 8;
const FOCUS_BORDER_STYLING = '1px solid #93BAD4';

export default class EquationEditor extends PureComponent {
  componentDidMount() {
    document.addEventListener('keydown', this.handleKeydown.bind(this), false);
  }

  componentWillUnmount() {
    document.removeEventListener('keydown', this.handleKeydown.bind(this), false);
  }

  setStyle(focus) {
    if (!focus) { return null; }
    return { border: FOCUS_BORDER_STYLING };
  }

  handleKeydown(event) {
    // Ignore key presses for calculators without the current focus
    if (!this.props.calculatorFocus) { return; }

    if (event.keyCode === RIGHT) this.props.arrowKeyPressed(true);
    if (event.keyCode === LEFT) this.props.arrowKeyPressed(false);
    if (event.keyCode === BACKSPACE) this.props.deletePreviousToken();
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
        <div className="ui segment" style={this.setStyle(this.props.calculatorFocus)}>
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
  calculatorFocus: PropTypes.bool.isRequired,
  arrowKeyPressed: PropTypes.func.isRequired,
  deletePreviousToken: PropTypes.func.isRequired
};
