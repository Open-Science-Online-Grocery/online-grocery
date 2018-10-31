import { connect } from 'react-redux';
import StylerForm from '../components/StylerForm';
import { getActiveSelector } from '../store';
import CssConverter from '../utils/CssConverter';
import { setStyle } from '../actions';

const mapStateToProps = ($$state) => {
  const activeSelector = getActiveSelector($$state);
  const cssConverter = new CssConverter(activeSelector);
  return {
    activeSelector,
    disabled: !activeSelector,
    fontFamily: cssConverter.fontFamily(),
    fontSize: cssConverter.fontSize(),
    fontColor: cssConverter.fontColor(),
    backgroundColor: cssConverter.backgroundColor()
  };
};

const mapDispatchToProps = dispatch => (
  {
    setStyle: (activeSelector, property, value) => {
      dispatch(setStyle(activeSelector, property, value));
    }
  }
);

export default connect(mapStateToProps, mapDispatchToProps)(StylerForm);
