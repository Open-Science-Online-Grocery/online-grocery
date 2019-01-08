import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { Icon, Message } from 'semantic-ui-react';

export default class WarningMessage extends PureComponent {
  render() {
    if (!this.props.incompleteDataVariables.length) return null;
    return (
      <div>
        <Message size="tiny" icon warning>
          <Icon name="exclamation circle" />
          <Message.Content>
            <Message.Header>
              Warning: Not all products have information for the following fields.
              This may result in biased calculations.
            </Message.Header>
            <ul>
              {
                this.props.incompleteDataVariables.map(
                  variableName => <li key={variableName}>{variableName}</li>
                )
              }
            </ul>
          </Message.Content>
        </Message>
      </div>
    );
  }
}

WarningMessage.propTypes = {
  incompleteDataVariables: PropTypes.arrayOf(PropTypes.string).isRequired
};
