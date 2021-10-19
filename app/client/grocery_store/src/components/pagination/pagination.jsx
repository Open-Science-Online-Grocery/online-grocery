import React from 'react';
import PropTypes from 'prop-types';
import './pagination.scss';

export default class Pagination extends React.Component {
  goToPage(requestedPage) {
    const { requestPage } = this.props;
    document.body.scrollTop = document.documentElement.scrollTop = 0;
    requestPage(requestedPage);
  }

  prevPage() {
    const { currentPage } = this.props;
    if (currentPage === 1) {
      return (
        <span className="disabled">{'<'}</span>
      );
    }
    return (
      <a onClick={() => this.goToPage(currentPage - 1)}>{'<'}</a>
    );
  }

  nextPage() {
    const { currentPage, totalPages } = this.props;
    if (currentPage === totalPages) {
      return (
        <span className="disabled">{'>'}</span>
      );
    }
    return (
      <a onClick={() => this.goToPage(currentPage + 1)}>{'>'}</a>
    );
  }

  pageNumbers() {
    const { currentPage, totalPages } = this.props;
    const nums = Array.from({ length: totalPages }, (_v, i) => i + 1);
    return nums.map((pageNumber) => {
      if (pageNumber === currentPage) {
        return (<span key={pageNumber} className="disabled">{pageNumber}</span>);
      }
      return (
        <a
          onClick={() => this.goToPage(pageNumber)}
          key={pageNumber}
        >
          {pageNumber}
        </a>
      );
    });
  }

  render() {
    const { currentPage, totalPages } = this.props;
    return (
      <div className="pagination">
        {this.prevPage()}
        {this.pageNumbers()}
        {this.nextPage()}
      </div>
    );
  }
}

Pagination.propTypes = {
  currentPage: PropTypes.number.isRequired,
  totalPages: PropTypes.number.isRequired,
  requestPage: PropTypes.func.isRequired
};
