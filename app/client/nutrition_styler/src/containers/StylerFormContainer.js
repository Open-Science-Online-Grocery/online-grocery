import { connect } from 'react-redux';
import StylerForm from '../components/StylerForm';
import { getActiveSelector, getActiveRules } from '../store';
import CssConverter from '../utils/CssConverter';
import { setStyle } from '../actions';

const mapStateToProps = ($$state) => {
  const activeSelector = getActiveSelector($$state);
  const activeSelectorRules = getActiveRules($$state);
  const cssConverter = new CssConverter(activeSelector, activeSelectorRules);
  return {
    activeSelector,
    disabled: !activeSelector,
    fontFamily: cssConverter.fontFamily(),
    fontSize: cssConverter.fontSize(),
    fontColor: cssConverter.fontColor(),
    backgroundColor: cssConverter.backgroundColor(),
    bold: cssConverter.bold(),
    italic: cssConverter.italic(),
    strikethrough: cssConverter.strikethrough(),
    underline: cssConverter.underline()
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
