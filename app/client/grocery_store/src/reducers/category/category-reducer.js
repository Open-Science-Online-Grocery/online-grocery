import { categoryActionTypes } from './category-actions';
import { userActionTypes } from '../user/user-actions';

const initialCategoryState = {
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

export function tabIsSelected(state, categoryType, categoryId) {
  const { selectedCategoryType, selectedCategoryId  } = state;
  return categoryType === selectedCategoryType &&
    categoryId == selectedCategoryId;
}

export default function categoryReducer(state = initialCategoryState, action) {
  const {
    categories, subcategories, subsubcategories, products, selectedCategoryId,
    selectedSubcategoryId, selectedSubsubcategoryId, tags, subtags,
    selectedCategoryType
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
        products
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
