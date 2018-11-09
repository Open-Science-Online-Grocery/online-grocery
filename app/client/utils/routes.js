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

export function productSearch() {
  return {
    url: '/api/product_search',
    method: 'GET'
  };
}

export function addParticipantAction() {
  return {
    url: '/api/participant_actions',
    method: 'POST'
  };
}
