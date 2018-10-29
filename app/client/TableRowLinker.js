// This class is used to attach link handling to <tr> elements
export default class TableRowLinker {
  constructor($scope) {
    this.$scope = $scope;
    this.$linkRows = this.$scope.find('tr[data-action="table-link"]');
  }

  init() {
    if (this.$linkRows.length) {
      this.setupLinks();
      this.preventUnwantedEvents();
    }
  }

  setupLinks() {
    this.$linkRows.click((event) => {
      const $target = $(event.currentTarget);
      const dataHref = $target.data('href');
      const firstLinkHref = $target.find('a').attr('href');
      const checkTarget = $(event.target);
      if (checkTarget.attr('href') !== undefined) {
        return;
      }
      const path = (dataHref || firstLinkHref);
      if ($target.data('remote')) {
        $.getScript(path);
      } else {
        window.location.href = path;
      }
    });
  }

  preventUnwantedEvents() {
    const propagatables = this.$scope.find(
      '[data-action=table-link] input, [data-action=no-table-link]'
    );
    propagatables.click((event) => {
      event.stopPropagation();
      const link = event.target.closest('a');
      if (!link) return;
      if (link.dataset.method) {
        // this calls a method in `rails-ujs` which handles non-GET links
        $.rails.handleMethod.bind(link)(event);
      } else if (link.dataset.remote) {
        // this calls a method in `rails-ujs` which handles remote links
        $.rails.handleRemote.bind(link)(event);
      }
    });
  }
}
