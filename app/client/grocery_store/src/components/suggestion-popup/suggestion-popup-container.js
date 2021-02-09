import { connect } from 'react-redux';
import SuggestionPopup from './suggestion-popup';
// import { alertActionCreators } from '../../reducers/alert/alert-actions';

const mapStateToProps = state => (
  {
    visible: state.suggestion.visible,
    title: state.suggestion.title,
    product: state.suggestion.product
  }
);

const mapDispatchToProps = dispatch => (
  {
    handleDismiss: () => {
      // dispatch(alertActionCreators.dismissAlert());
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(SuggestionPopup);
