import humps from 'humps';
import fetch from 'isomorphic-fetch';
import UnauthorizedRequestHandler from './UnauthorizedRequestHandler';

function jsonPost(route, data) {
  const tokenMeta = document.querySelector('meta[name=csrf-token]');
  const token = tokenMeta && tokenMeta.content;
  return fetch(
    route.url,
    {
      credentials: 'include',
      method: route.method,
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': token
      },
      body: JSON.stringify(data)
    }
  );
}

function jsonGet(route, data) {
  const url = `${route.url}?${$.param(data)}`;
  return fetch(url, { credentials: 'include' });
}

function checkResponse(response) {
  if (response.ok) { return response.json(); }
  return Promise.reject(response);
}

function handleFailure(response, failureCallback) {
  if (response.status === 401) {
    new UnauthorizedRequestHandler().showFlash();
  } else {
    failureCallback(response.statusText || response);
  }
}

function callApi(route, data) {
  return route.method === 'GET' ? jsonGet(route, data) : jsonPost(route, data);
}

// @param {Object} route - an object of the following shape:
//   {
//     url: <a url to post data to or fetch data from>,
//     method: <a string representing an HTTP method, like 'GET' or 'PUT'>
//   }
// @param {Object} data - data that should be sent to the API endpoint.
// @param {function} successFunc - a function that should be run if the API
//   call succeeds. will receive the JSON response as its sole argument.
// @param {function} failureFunc - a function that should be run if the API
//   call fails. will receive either the response's `statusText` (if available)
//   or the response itself as its sole argument.
//
// eslint-disable-next-line import/prefer-default-export
export function jsonApiCall(route, data, successFunc, failureFunc) {
  const underscoredData = humps.decamelizeKeys(data);
  callApi(route, underscoredData)
    .then(response => checkResponse(response))
    .then(json => successFunc(humps.camelizeKeys(json)))
    .catch(response => handleFailure(response, failureFunc));
}
