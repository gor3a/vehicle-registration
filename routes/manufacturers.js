const ManufacturersController = require("../app/controllers/ManufacturersController");

function manufacturersRoutes(app) {
    app.get("/manufacturers", ManufacturersController().allManufacturers)
}

module.exports = manufacturersRoutes
