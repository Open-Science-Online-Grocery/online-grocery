export default class CocoonCallbacks {
  initialize() {
    this.addEquationAttributeEventListener('[data-cart-summary-labels]', 'cocoon:after-insert');
    this.addCartSummaryLabelEquationAttribute(null, $('[data-cart-summary-label]'));
  }

  addEquationAttributeEventListener(targetIdentifier, addEvent) {
    $(targetIdentifier).on(addEvent, this.addCartSummaryLabelEquationAttribute.bind(this));
  }

  // this method adds an input name attribute needed by React to render the Equation widget.
  // this input needs to be set manually after the cocoon element is inserted
  // (either by cocoon's JS or on page load) in order to assign it the correct Id
  // corresponding to the random one set by Cocoon
  addCartSummaryLabelEquationAttribute(_event, insertedItem) {
    const $insertedItem = $(insertedItem);
    const cocoonId = this.extractCocoonId($insertedItem.find('input').first());
    const inputName = `condition[condition_cart_summary_labels_attributes][${cocoonId}][label_equation_tokens]`;
    $insertedItem.find('[data-calculator]').attr('data-input-name', inputName); // TODO: this is not needed
    $insertedItem.find('.calculator').find('input:hidden').attr('name', inputName);
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
