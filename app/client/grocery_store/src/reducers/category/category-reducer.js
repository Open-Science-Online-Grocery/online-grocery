import { categoryActionTypes } from './category-actions';
import { userActionTypes } from '../user/user-actions';

const initialCategoryState = {
  page: 1,
  totalPages: 1,
  loaderActive: false,
  selectedCategoryId: null,
  selectedSubcategoryId: null,
  selectedSubsubcategoryId: null,
  selectedCategoryType: null,
  products: [],
  categories: [],
  subcategories: [],
  subsubcategories: [],
  tags: [],
  subtags: []
};

/* ****************************** selectors ********************************* */

export function getCategoryTitle(state) {
  const { selectedCategoryId, selectedCategoryType, tags, categories } = state;
  switch (selectedCategoryType) {
    case 'tag':
      return tags.find(tag => tag.id === selectedCategoryId).name;
    case 'category':
      return categories.find(category => category.id === selectedCategoryId).name;
    default:
      return null;
  }
}

export function subtabs(state, categoryType, categoryId) {
  const { subtags, subcategories } = state;
  switch (categoryType) {
    case 'tag':
      return subtags.filter(subtag => subtag.name && subtag.tagId === categoryId);
    case 'category':
      return subcategories.filter(subcat => subcat.categoryId === categoryId);
    default:
      return [];
  }
}

export function tabIsSelected(state, categoryType, categoryId) {
  const { selectedCategoryType, selectedCategoryId  } = state;
  return categoryType === selectedCategoryType &&
    categoryId == selectedCategoryId;
}

/* ******************************* reducers ********************************* */

export default function categoryReducer(state = initialCategoryState, action) {
  const {
    categories, subcategories, subsubcategories, products, selectedCategoryId,
    selectedSubcategoryId, selectedSubsubcategoryId, tags, subtags,
    selectedCategoryType, page, totalPages, loaderActive
  } = action;

  switch (action.type) {
    case categoryActionTypes.SET_CATEGORY:
      return Object.assign({}, state, {
        selectedCategoryId,
        selectedSubcategoryId,
        selectedSubsubcategoryId,
        selectedCategoryType
      });
    case categoryActionTypes.SET_PRODUCTS:
      return Object.assign({}, state, {
        page,
        totalPages,
        products
      });
    case categoryActionTypes.SET_LOADER:
      return Object.assign({}, state, {
        loaderActive
      });
    case userActionTypes.SET_CONDITION_DATA:
      return Object.assign({}, state, {
        categories,
        subcategories,
        subsubcategories,
        tags,
        subtags
      });
    default:
      return state;
  }
}
