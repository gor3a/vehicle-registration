const roles = require("../../utilities/roles");

function manufacture(req, res, next) {
    if (req.session.user && roles(req.session.user.user_role) === 'manufacture') {
        return next()
    }
    return res.redirect('/')
}

module.exports = manufacture
