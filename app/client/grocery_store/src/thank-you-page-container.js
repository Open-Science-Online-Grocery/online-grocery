import { connect } from 'react-redux';
import ThankYouPage from './thank-you-page';

const mapStateToProps = state => (
  {
    qualtricsCode: state.user.qualtricsCode
  }
);

export default connect(mapStateToProps)(ThankYouPage);
