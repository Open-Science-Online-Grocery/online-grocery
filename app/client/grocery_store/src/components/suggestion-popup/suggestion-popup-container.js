import { connect } from 'react-redux';
import SuggestionPopup from './suggestion-popup';
import { suggestionActionCreators } from '../../reducers/suggestion/suggestion-actions';

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
      dispatch(suggestionActionCreators.dismissSuggestion());
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(SuggestionPopup);
