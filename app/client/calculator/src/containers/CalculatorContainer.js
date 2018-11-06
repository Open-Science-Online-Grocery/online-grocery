import { connect } from 'react-redux';
import Calculator from '../components/Calculator';
import { getInputName, getTokensJson } from '../store';
import { testCalculation } from '../actions';

const mapStateToProps = $$state => (
  {
    inputName: getInputName($$state),
    tokensJson: getTokensJson($$state)
  }
);

const mapDispatchToProps = dispatch => (
  { testCalculation: () => dispatch(testCalculation()) }
);

export default connect(mapStateToProps, mapDispatchToProps)(Calculator);
