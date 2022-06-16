const roles = require("../../utilities/roles");

function admin(req, res, next) {
    if (req.session.user && roles[req.session.user.user_role] === 'bank') {
        return next()
    }
    return res.redirect('/')
}

module.exports = admin
