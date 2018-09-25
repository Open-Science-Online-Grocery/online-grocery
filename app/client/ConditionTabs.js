export default class ConditionTabs {
  init() {
    this.initTabs();
    this.handleSubmit();
  }

  initTabs() {
    $('.tabular.menu .item').tab();
    $.tab('change tab', 'basic-info')
  }

  handleSubmit() {
    $('body').on('click', '[data-tab-submit]', function() {
      $('.tab.active form').submit()
    })
  }
}
