import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import ProductDetailsContainer from '../product-details/product-details-container';
import './product-card-expanded.scss';

class ProductCardExpanded extends React.Component {
  componentDidMount() {
    this.props.logParticipantAction('view', this.props.id);
  }

  render() {
    return (
      <div>
        <span onClick={this.props.history.goBack} className="navigate-back">
          {"<"} Back to Browsing
        </span>
        <div className="product-card-expanded">
          <ProductDetailsContainer {...this.props.product} />
        </div>
      </div>
    );
  }
}

ProductCardExpanded.propTypes = {
  product: PropTypes.shape({
    id: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    starpoints: PropTypes.number,
    size: PropTypes.string.isRequired,
    price: PropTypes.string.isRequired,
    awsImageUrl: PropTypes.string.isRequired,
    description: PropTypes.string,
    ingredients: PropTypes.string,
    labels: PropTypes.arrayOf(
      PropTypes.shape({
        labelName: PropTypes.string,
        labelImageUrl: PropTypes.string,
        labelPosition: PropTypes.string,
        labelSize: PropTypes.number
      })
    ),
    servings: PropTypes.string,
    servingSize: PropTypes.string,
    calories: PropTypes.number,
    totalFat: PropTypes.number,
    saturatedFat: PropTypes.number,
    transFat: PropTypes.number,
    cholesterol: PropTypes.string,
    sodium: PropTypes.number,
    carbs: PropTypes.number,
    fiber: PropTypes.number,
    sugar: PropTypes.number,
    protein: PropTypes.number,
    vitamins: PropTypes.string,
  }).isRequired,
  logParticipantAction: PropTypes.func.isRequired
};

export default withRouter(ProductCardExpanded);
