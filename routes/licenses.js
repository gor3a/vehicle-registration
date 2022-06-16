const LicensesController = require("../app/controllers/LicensesController");

function licensesRoutes(app) {
    app.get("/licenses", LicensesController().allLicenses)
    app.get("/licenses/add", LicensesController().add)
    app.get("/licenses/renewal/:id/:expire_at", LicensesController().renewal)
}

module.exports = licensesRoutes
