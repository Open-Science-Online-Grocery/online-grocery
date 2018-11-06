import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { Button, Icon, Select } from 'semantic-ui-react';

export default class VariableSelector extends PureComponent {
  constructor(props) {
    super(props);
    this.state = { selectedVariable: '' };
    this.handleSelectChange = (event, data) => (
      this.setState({ selectedVariable: data.value })
    );
    this.onButtonClick = this.handleButtonClick.bind(this);
  }

  handleButtonClick() {
    if (this.state.selectedVariable.length) {
      this.props.selectToken(this.state.selectedVariable);
    }
  }

  options() {
    const variables = Object.entries(this.props.variables).map(
      ([token, description]) => ({ value: token, text: description })
    );
    return [{ value: '', text: '' }].concat(variables);
  }

  render() {
    return (
      <div className="insert-field">
        <Select
          options={this.options()}
          value={this.state.selectedVariable}
          onChange={this.handleSelectChange}
          placeholder="Select a field"
        />
        <Button type="button" onClick={this.onButtonClick}>
          <Icon name="plus" />
          Insert field into calculation
        </Button>
      </div>
    );
  }
}

VariableSelector.propTypes = {
  variables: PropTypes.objectOf(PropTypes.string).isRequired,
  selectToken: PropTypes.func.isRequired
};
