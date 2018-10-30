import { connect } from 'react-redux';
import StylerForm from '../components/StylerForm';
import { getActiveSelector } from '../store';

const mapStateToProps = $$state => (
  { activeSelector: getActiveSelector($$state) }
);

export default connect(mapStateToProps)(StylerForm);
