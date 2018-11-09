import { connect } from 'react-redux';
import TopNav from './top-nav';

const mapStateToProps = state => (
  { conditionIdentifier: state.user.conditionIdentifier }
);

export default connect(mapStateToProps)(TopNav);
