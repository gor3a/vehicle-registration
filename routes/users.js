const UsersController = require("../app/controllers/UsersController");
const guest = require("../app/middlewares/guest");

function userRoutes(app) {
    app.get("/signup", guest, UsersController().signup)
    app.post("/signup", guest, UsersController().signupPost)

    app.get("/login", guest, UsersController().login)
    app.post("/login", guest, UsersController().loginPost)

    app.get("/logout", UsersController().logout)

    app.get("/users", UsersController().users)

    app.get("/profile", UsersController().profile)
    app.post("/profile", UsersController().profilePost)
}

module.exports = userRoutes;
