import { connect } from 'react-redux';
import Calculator from '../components/Calculator';
import { getInputName, getTokensJson } from '../store';

const mapStateToProps = $$state => (
  {
    inputName: getInputName($$state),
    tokensJson: getTokensJson($$state)
  }
);

export default connect(mapStateToProps)(Calculator);
