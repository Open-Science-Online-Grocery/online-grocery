import { connect } from 'react-redux';
import StylerForm from '../components/StylerForm';
import { getActiveSelector } from '../store';
import CssConverter from '../utils/CssConverter';

const mapStateToProps = ($$state) => {
  const activeSelector = getActiveSelector($$state);
  const cssConverter = new CssConverter(activeSelector);
  return {
    disabled: !activeSelector,
    fontFamily: cssConverter.fontFamily(),
    fontSize: cssConverter.fontSize(),
    fontColor: cssConverter.fontColor(),
    backgroundColor: cssConverter.backgroundColor()
  };
};

export default connect(mapStateToProps)(StylerForm);
