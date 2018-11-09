var db = require ('../index')

var Products = {
  getCategoryProducts: function(category, subcategory, callback){
    return db.query(`SELECT * FROM products WHERE category=${category} AND subcategory=${subcategory}`, callback)
  },
  searchProducts: function(search, callback){
    return db.query(`SELECT * FROM products WHERE name LIKE "%${search}%"`, callback)
  }
}
module.exports= Products;
