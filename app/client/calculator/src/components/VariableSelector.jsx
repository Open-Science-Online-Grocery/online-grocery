import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { Button, Icon, Select } from 'semantic-ui-react';

export default class VariableSelector extends PureComponent {
  options() {
    const variables = Object.entries(this.props.variables).map(
      ([token, description]) => ({ value: token, text: description })
    );
    return [{ value: '', text: '' }].concat(variables);
  }

  render() {
    return (
      <div className="insert-field">
        <Select options={this.options()} placeholder="Select a field" />
        <Button type="button">
          <Icon name="plus" />
          Insert field into calculation
        </Button>
      </div>
    );
  }
}

VariableSelector.propTypes = {
  variables: PropTypes.objectOf(PropTypes.string).isRequired
};
