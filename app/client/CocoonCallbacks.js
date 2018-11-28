import calculator from './calculator/src/index';

export default class CocoonCallbacks {
  initialize() {
    $('[data-cart-summary-label]').each(
      (_index, renderedLabel) => {
        this.initializeCalculator($(renderedLabel));
      }
    );
    $('[data-cart-summary-labels]').on(
      'cocoon:after-insert',
      (_event, $insertedItem) => this.initializeCalculator($insertedItem)
    );

    $('[data-cart-summary-labels]').on(
      'cocoon:after-remove',
      this.triggerFormRefresh
    );
  }

  triggerFormRefresh() {
    $('[data-cart-summary-labels]').closest('form')
      .find('[data-refresh-form]')
      .first()
      .trigger('change');
  }

  // this method adds an input name attribute needed by React to render the Equation widget.
  // this input needs to be set manually after the cocoon element is inserted
  // (either by cocoon's JS or on page load) in order to assign it the correct Id
  // corresponding to the random one set by Cocoon. It also then must initialize the
  // calculator to ensure the added attribute gets into React props
  initializeCalculator($insertedItem) {
    if ($insertedItem.length === 0) return;
    const cocoonId = this.extractCocoonId($insertedItem.find('input').first());
    const inputName = `condition[condition_cart_summary_labels_attributes][${cocoonId}][equation_tokens]`;
    $insertedItem.find('[data-calculator]').attr('data-input-name', inputName);
    calculator($insertedItem.find('[data-calculator]')[0]);
  }

  extractCocoonId($input) {
    // $input should be a cocoon input with a name like
    // "condition[condition_cart_summary_labels_attributes][COCOON_ID][ATTRIBUTE_NAME]"
    // this method splits on `[`, gets the cocoon id from the split, and removes the trailing `]`
    return $input.attr('name')
      .split('[')[2]
      .slice(0, -1);
  }
}
