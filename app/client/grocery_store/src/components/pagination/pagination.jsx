import React from 'react';
import './pagination.scss';

export default class Pagination extends React.Component {
  prevPage() {
    const { currentPage } = this.props;
    if (currentPage === 1) {
      return (
        <span className="disabled">{'<'}</span>
      );

    }
    // TODO: onclick listener
    return (
      <a>{'<'}</a>
    );
  }

  nextPage() {
    const { currentPage, totalPages } = this.props;
    if (currentPage === totalPages) {
      return (
        <span className="disabled">{'>'}</span>
      );
    }
    // TODO: onclick listener
    return (
      <a>{'>'}</a>
    );
  }

  pageNumbers() {
    const { currentPage, totalPages } = this.props;
    const nums = Array.from({ length: totalPages }, (_v, i) => i + 1);
    return nums.map((pageNumber) => {
      if (pageNumber === currentPage) {
        return (<span key={pageNumber} className="active">{pageNumber}</span>);
      }
      // TODO: onclick listener
      return (<a key={pageNumber}>{pageNumber}</a>);
    });
  }

  render() {
    const { currentPage, totalPages } = this.props;
    if (totalPages === 1) return null;

    return (
      <div className="pagination">
        <div className="page-links">
          {this.prevPage()}
          {this.pageNumbers()}
          {this.nextPage()}
        </div>
      </div>
    );
  }
}
