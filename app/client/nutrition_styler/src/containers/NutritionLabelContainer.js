import { connect } from 'react-redux';
import NutritionLabel from '../components/NutritionLabel';
import { setActiveSelector } from '../actions';

const mapDispatchToProps = dispatch => (
  { setActiveSelector: selector => dispatch(setActiveSelector(selector)) }
);

export default connect(null, mapDispatchToProps)(NutritionLabel);
