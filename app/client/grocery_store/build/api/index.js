var express = require('express');
var api = express.Router();
var Products = require('./../db/models/Products')
var Users = require('./../db/models/Users')
var Categories = require('./../db/models/Categories')

api.get('/categories', (req, res, next)=>{
  Categories.getCategories(function (err, rows){
    if(err)
    {
      res.json(err);
    }
    else
    {
      res.json(rows);
    }

  });
})
api.get('/subcategories', (req, res, next)=>{
  Categories.getSubcategories(function (err, rows){
    if(err)
    {
      res.json(err);
    }
    else
    {
      res.json(rows);
    }

  });
})
api.get('/category', (req, res, next)=>{
  Products.getCategoryProducts(req.query.category, req.query.subcategory, function (err, rows){
    if(err)
    {
    res.json(err);
    }
    else
    {
    res.json(rows);
    }

  });
})
api.get('/search', (req, res, next)=>{
  Products.searchProducts(req.query.search, function (err, rows){
    if(err)
    {
    res.json(err);
    }
    else
    {
    res.json(rows);
    }

  });
})
api.get('/users', (req, res, next)=>{
  Users.getAllUsers(function (err, rows){
    if(err)
    {
    res.json(err);
    }
    else
    {
    res.json(rows);
    }

  });
})
api.post('/user', (req, res, next)=>{
  Users.addUserAction(req.body, function (err, count){
    if(err)
    {
    res.json(err);
    }
    else
    {
    res.json(req.body);
    }

  });
})
module.exports = api
