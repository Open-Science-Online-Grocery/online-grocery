var db = require ('../index')

var Categories = {
    getCategories: function(callback){
        return db.query(`SELECT * FROM categories ORDER BY id`, callback)
    },
    getSubcategories: function(callback){
        return db.query(`SELECT * FROM subcategories ORDER BY category_id, display_order`, callback)
    }
}
module.exports= Categories;
