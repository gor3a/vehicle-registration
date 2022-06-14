const UsersController = require("../app/controllers/UsersController");
const guest = require("../app/middlewares/guest");
const auth = require("../app/middlewares/auth");

function userRoutes(app) {
    app.get("/signup", guest, UsersController().signup)
    app.post("/signup", guest, UsersController().signupPost)

    app.get("/login", guest, UsersController().login)
    app.post("/login", guest, UsersController().loginPost)

    app.get("/logout", UsersController().logout)

    app.get("/users", auth, UsersController().users)

    app.get("/profile", auth, UsersController().profile)
    app.post("/profile", auth, UsersController().profilePost)
}

module.exports = userRoutes;
