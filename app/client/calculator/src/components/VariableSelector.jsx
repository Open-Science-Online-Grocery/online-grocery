import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import { Button, Icon, Select } from 'semantic-ui-react';

export default class VariableSelector extends PureComponent {
  constructor(props) {
    super(props);
    this.state = { selectedToken: '' };
    this.handleSelectChange = (event, data) => (
      this.setState({ selectedToken: data.value })
    );
    this.onButtonClick = this.handleButtonClick.bind(this);
  }

  handleButtonClick() {
    if (this.state.selectedToken.length) {
      this.props.selectToken(this.state.selectedToken);
    }
  }

  options() {
    // sorting alphabetically by description
    const sortedVariables = this.props.variables
      .sort((a, b) => a.description.localeCompare(b.description));
    const variables = sortedVariables.map(
      (variable) => ({ value: variable.token, text: variable.description })
    );
    return [{ value: '', text: '' }].concat(variables);
  }

  render() {
    return (
      <div className="insert-field">
        <Select
          options={this.options()}
          value={this.state.selectedToken}
          onChange={this.handleSelectChange}
          placeholder="Select a field"
        />
        <Button className="insert" type="button" onClick={this.onButtonClick}>
          <Icon name="plus" />
          Insert field
        </Button>
        <Button icon type="button" onClick={this.props.deletePreviousToken}>
          <Icon name="arrow left" />
        </Button>
      </div>
    );
  }
}

VariableSelector.propTypes = {
  variables: PropTypes.arrayOf(
    PropTypes.shape({
      token: PropTypes.string,
      description: PropTypes.string,
      incompleteData: PropTypes.bool
    })
  ).isRequired,
  selectToken: PropTypes.func.isRequired,
  deletePreviousToken: PropTypes.func.isRequired
};
