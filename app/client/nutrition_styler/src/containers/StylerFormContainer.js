import { connect } from 'react-redux';
import StylerForm from '../components/StylerForm';
import { getActiveSelector, getActiveRules, getActiveOriginalRules } from '../store';
import { setStyle, resetSelection } from '../actions';

const mapStateToProps = ($$state) => {
  const activeSelector = getActiveSelector($$state);
  const activeSelectorRules = getActiveRules($$state);
  const activeSelectorOriginalRules = getActiveOriginalRules($$state);
  const currentRules = Object.assign(activeSelectorOriginalRules, activeSelectorRules);
  return {
    activeSelector,
    disabled: !activeSelector,
    ...currentRules
  };
};

const mapDispatchToProps = dispatch => (
  {
    setStyle: (activeSelector, property, value) => {
      dispatch(setStyle(activeSelector, property, value));
    },
    resetSelection: (activeSelector) => {
      dispatch(resetSelection(activeSelector));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(StylerForm);
