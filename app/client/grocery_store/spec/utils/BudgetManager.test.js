import BudgetManager from '../../src/utils/BudgetManager';

describe('with a cart price of 0', () => {
  const subject = new BudgetManager(0, 0, 0);

  describe('subtotal', () => {
    it('returns the expected string', () => {
      expect(subject.subtotal()).toEqual('0.00');
    });
  });

  describe('tax', () => {
    it('returns the expected string', () => {
      expect(subject.tax()).toEqual('0.00');
    });
  });

  describe('total', () => {
    it('returns the expected string', () => {
      expect(subject.total()).toEqual('0.00');
    });
  });
});

describe('with a nonzero cart price', () => {
  const subject = new BudgetManager(10, 0, 0);

  describe('subtotal', () => {
    it('returns the expected string', () => {
      expect(subject.subtotal()).toEqual('10.00');
    });
  });

  describe('tax', () => {
    it('returns the expected string', () => {
      expect(subject.tax()).toEqual('0.75');
    });
  });

  describe('total', () => {
    it('returns the expected string', () => {
      expect(subject.total()).toEqual('10.75');
    });
  });
});

describe('when over max spend', () => {
  const subject = new BudgetManager(10.01, 10, 5);

  describe('overMaxSpend', () => {
    it('returns true', () => {
      expect(subject.overMaxSpend()).toEqual(true);
    });
  });

  describe('underMinSpend', () => {
    it('returns false', () => {
      expect(subject.underMinSpend()).toEqual(false);
    });
  });

  describe('checkoutErrorMessage', () => {
    it('returns the expected message', () => {
      expect(subject.checkoutErrorMessage()).toEqual(
        'In order to check out, you must spend less than $10.00.'
      );
    });
  });
});

describe('when under min spend', () => {
  const subject = new BudgetManager(4.99, 10, 5);

  describe('overMaxSpend', () => {
    it('returns false', () => {
      expect(subject.overMaxSpend()).toEqual(false);
    });
  });

  describe('underMinSpend', () => {
    it('returns true', () => {
      expect(subject.underMinSpend()).toEqual(true);
    });
  });

  describe('checkoutErrorMessage', () => {
    it('returns the expected message', () => {
      expect(subject.checkoutErrorMessage()).toEqual(
        'In order to check out, you must spend more than $5.00.'
      );
    });
  });
});

describe('when within budget constraints', () => {
  const subject = new BudgetManager(6, 10, 5);

  describe('overMaxSpend', () => {
    it('returns false', () => {
      expect(subject.overMaxSpend()).toEqual(false);
    });
  });

  describe('underMinSpend', () => {
    it('returns false', () => {
      expect(subject.underMinSpend()).toEqual(false);
    });
  });

  describe('checkoutErrorMessage', () => {
    it('returns null', () => {
      expect(subject.checkoutErrorMessage()).toEqual(null);
    });
  });
});
