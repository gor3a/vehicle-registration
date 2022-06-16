function homeRoutes(app) {
    app.get("/", function (req, res, next) {
        // console.log(res.locals, req.session, req.locals)
        if (!req.session.user) {
            res.render("home")
        } else {
            res.render("user/profile", {
                user: req.session.user
            })
        }
    })
}

module.exports = homeRoutes
