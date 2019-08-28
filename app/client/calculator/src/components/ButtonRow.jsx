import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { Button } from 'semantic-ui-react';

export default class ButtonRow extends PureComponent {
  render() {
    return (
      <Button.Group className={this.props.className}>
        {
          this.props.values.map(
            (value) => (
              <Button
                key={value}
                type="button"
                onClick={() => this.props.selectToken(value)}
              >
                {value}
              </Button>
            )
          )
        }
      </Button.Group>
    );
  }
}

ButtonRow.propTypes = {
  className: PropTypes.string.isRequired,
  values: PropTypes.arrayOf(PropTypes.string).isRequired,
  selectToken: PropTypes.func.isRequired
};
