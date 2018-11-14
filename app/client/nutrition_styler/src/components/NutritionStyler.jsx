import React, { PureComponent } from 'react';
import NutritionLabelPreviewContainer from '../containers/NutritionLabelPreviewContainer';
import StylerFormContainer from '../containers/StylerFormContainer';

export default class NutritionStyler extends PureComponent {
  render() {
    return (
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
  }
}
