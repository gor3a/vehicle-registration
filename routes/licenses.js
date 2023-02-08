const LicensesController = require("../app/controllers/LicensesController");
const auth = require("../app/middlewares/auth")

function licensesRoutes(app) {
    app.get("/licenses", auth, LicensesController().allLicenses)
    app.get("/licenses/add", auth, LicensesController().add)
    app.get("/licenses/renewal/:id/:expire_at", auth, LicensesController().renewal)
}

module.exports = licensesRoutes
