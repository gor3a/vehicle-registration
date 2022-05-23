function homeRoutes(app){
    app.get("/", function (req,res,next){
        res.render("home")
    })
}

module.exports = homeRoutes
