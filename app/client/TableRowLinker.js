// This class is used to attach link handling to <tr> elements
export default class TableRowLinker {
  constructor($scope) {
    this.$scope = $scope;
    this.$linkRows = this.$scope.find('tr[data-action="table-link"]');
  }

  initialize() {
    if (this.$linkRows.length) {
      this.setupLinks();
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
}
