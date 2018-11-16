import { connect } from 'react-redux';
import Calculator from '../components/Calculator';
import { getInputName, getTokensJson, getTokens } from '../store';
import { testCalculation } from '../actions';

const mapStateToProps = $$state => (
  {
    inputName: getInputName($$state),
    tokensJson: getTokensJson($$state),
    testable: getTokens($$state).length > 0
  }
);

const mapDispatchToProps = dispatch => (
  { testCalculation: () => dispatch(testCalculation()) }
);

export default connect(mapStateToProps, mapDispatchToProps)(Calculator);
