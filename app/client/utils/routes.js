// eslint-disable-next-line import/prefer-default-export
export function equationValidation() {
  return {
    url: '/api/equation_validation.json',
    method: 'GET'
  };
}

export function categoryProducts() {
  return {
    url: '/api/category',
    method: 'GET'
  };
}

export function categories() {
  return {
    url: '/api/categories',
    method: 'GET'
  };
}

export function subcategories() {
  return {
    url: '/api/subcategories',
    method: 'GET'
  };
}
