import { connect } from 'react-redux';
import ButtonRow from '../components/ButtonRow';
import { selectToken } from '../actions';

const mapDispatchToProps = dispatch => (
  { selectToken: value => dispatch(selectToken('operator', value)) }
);

export default connect(null, mapDispatchToProps)(ButtonRow);
