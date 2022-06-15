const LicensesController = require("../app/controllers/LicensesController");

function licensesRoutes(app) {
    app.get("/licenses", LicensesController().allLicenses)
}

module.exports = licensesRoutes
