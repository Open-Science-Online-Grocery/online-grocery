import { connect } from 'react-redux';
import TopNav from './top-nav';

const mapStateToProps = state => (
  // TODO: get props from state rather than parent component (HomePage)
  {}
);

export default connect(mapStateToProps)(TopNav);
