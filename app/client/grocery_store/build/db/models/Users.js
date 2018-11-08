var db = require ('../index')

var Users = {
  getAllUsers: function(callback){
    return db.query("SELECT * FROM users limit 50",callback);
  },
  addUserAction: function(User, callback){
    return db.query("INSERT into users values(?,?,?,?,?)", ['default', User.sessionID, User.actionType, User.product, User.quantity], callback)
  }
}
module.exports= Users;
