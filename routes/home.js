function homeRoutes(app) {
    app.get("/", function (req, res, next) {
        if (!req.session.user) {
            res.render("home")
        } else {
            res.render("dashboard")
        }
    })
}

module.exports = homeRoutes
