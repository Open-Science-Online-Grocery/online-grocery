import { connect } from 'react-redux';
import NutritionLabelPreview from '../components/NutritionLabelPreview';
import { setActiveSelector } from '../actions';

const mapDispatchToProps = dispatch => (
  { setActiveSelector: selector => dispatch(setActiveSelector(selector)) }
);

export default connect(null, mapDispatchToProps)(NutritionLabelPreview);
