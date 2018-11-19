import { connect } from 'react-redux';
import NutritionLabelPreview from '../components/NutritionLabelPreview';
import { setActiveSelector } from '../actions';
import { getCssRules } from '../store';

const mapStateToProps = $$state => (
  {
    cssRules: getCssRules($$state)
  }
);

const mapDispatchToProps = dispatch => (
  { setActiveSelector: selector => dispatch(setActiveSelector(selector)) }
);

export default connect(mapStateToProps, mapDispatchToProps)(NutritionLabelPreview);
