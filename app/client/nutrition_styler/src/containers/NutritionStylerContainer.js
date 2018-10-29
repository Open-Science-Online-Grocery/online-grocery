import { connect } from 'react-redux';
import NutritionStyler from '../components/NutritionStyler';
import { getCssRules } from '../store';

const mapStateToProps = $$state => (
  {
    cssRules: getCssRules($$state)
  }
);

export default connect(mapStateToProps)(NutritionStyler);
