// This class is used to attach link handling to <tr> elements
export default class TableRowLinker {
  constructor($scope) {
    this.$scope = $scope;
    this.$linkRows = this.$scope.find('tr[data-action="table-link"] td:not([data-action="cell-link"])');
    this.$linkCells = this.$scope.find('td[data-action="cell-link"]');
  }

  init() {
    if (this.$linkRows.length) {
      this.setupLinks();
    }
    if (this.$linkCells.length) {
      this.setupCellLinks();
    }
  }

  setupLinks() {
    this.$linkRows.click((event) => {
      const $target = $(event.currentTarget);
      const dataHref = $target.parent().data('href');
      const checkTarget = $(event.target);
      if (checkTarget.attr('href') !== undefined) {
        return;
      }
      if ($target.data('remote')) {
        $.getScript(path);
      } else {
        window.location.href = dataHref;
      }
    });
  }

  setupCellLinks() {
    this.$linkCells.click((event) => {
      const $target = $(event.currentTarget);
      const firstLink = $target.find('a');
      if (firstLink.length != 0) {
        firstLink.trigger('click');
      }
    });
  }
}
