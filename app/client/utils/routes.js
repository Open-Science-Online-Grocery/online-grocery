export function equationValidation() {
  return {
    url: '/api/equation_validation.json',
    method: 'GET'
  };
}

export function products() {
  return {
    url: '/api/products',
    method: 'GET'
  };
}

export function addParticipantAction() {
  return {
    url: '/api/participant_actions',
    method: 'POST'
  };
}

export function condition() {
  return {
    url: '/api/condition',
    method: 'GET'
  };
}

export function cartSettings() {
  return {
    url: '/api/cart_settings',
    method: 'GET'
  };
}
