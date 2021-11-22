import * as fromSubject from '../../../src/reducers/category/category-reducer';

describe('getCategoryTitle', () => {
  const state = {
    tags: [{ id: 11, name: 'foo' }, { id: 22, name: 'bar' }],
    categories: [{ id: 11, name: 'baz' }, { id: 22, name: 'qux' }],
    selectedCategoryId: 11
  };

  describe('when category type is tag', () => {
    beforeEach(() => {
      state.selectedCategoryType = 'tag';
    });

    it('returns the expected string', () => {
      expect(fromSubject.getCategoryTitle(state)).toEqual('foo');
    });
  });

  describe('when category type is category', () => {
    beforeEach(() => {
      state.selectedCategoryType = 'category';
    });

    it('returns the expected string', () => {
      expect(fromSubject.getCategoryTitle(state)).toEqual('baz');
    });
  });

  describe('when category type is something else', () => {
    beforeEach(() => {
      state.selectedCategoryType = '???';
    });

    it('returns null', () => {
      expect(fromSubject.getCategoryTitle(state)).toEqual(null)
    });
  });
});

describe('subtabs', () => {
  const subtag1 = { name: 'a', tagId: 11 };
  const subtag2 = { name: 'b', tagId: 22 };
  const subtag3 = { name: 'c', tagId: 11 };
  const subcategory1 = { name: 'x', categoryId: 11 };
  const subcategory2 = { name: 'y', categoryId: 22 };
  const subcategory3 = { name: 'z', categoryId: 11 };

  const state = {
    subtags: [subtag1, subtag2, subtag3],
    subcategories: [subcategory1, subcategory2, subcategory3]
  };

  describe('when category type is tag', () => {
    it('returns the expected objects', () => {
      expect(fromSubject.subtabs(state, 'tag', 11)).toEqual([subtag1, subtag3])
    });
  });

  describe('when category type is category', () => {
    it('returns the expected objects', () => {
      expect(fromSubject.subtabs(state, 'category', 11)).toEqual(
        [subcategory1, subcategory3]
      );
    })
  });

  describe('when category type is something else', () => {
    it('returns null', () => {
      expect(fromSubject.subtabs(state, '???', 11)).toEqual([]);
    })
  });
});

describe('tabIsSelected', () => {
  const state = {
    selectedCategoryType: 'tag',
    selectedCategoryId: 123
  };

  describe('when data matches selection', () => {
    expect(fromSubject.tabIsSelected(state, 'tag', 123)).toEqual(true);
  });

  describe('when data does not match selection', () => {
    expect(fromSubject.tabIsSelected(state, 'category', 123)).toEqual(false);
  });
});
