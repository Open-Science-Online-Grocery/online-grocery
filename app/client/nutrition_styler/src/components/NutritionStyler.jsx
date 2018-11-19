import React from 'react';
import NutritionLabelPreviewContainer from '../containers/NutritionLabelPreviewContainer';
import StylerFormContainer from '../containers/StylerFormContainer';

const NutritionStyler = () => (
  <div className="nutrition-styler">
    <div className="styler-form">
      <StylerFormContainer />
    </div>
    <div className="nutrition-label">
      <div className="nutrition-label-wrapper">
        <NutritionLabelPreviewContainer />
      </div>
    </div>
  </div>
);

export default NutritionStyler;
