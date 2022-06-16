const ManufacturersController = require("../app/controllers/ManufacturersController");
const admin = require("../app/middlewares/admin");

function manufacturersRoutes(app) {
    app.get("/manufacturers", admin, ManufacturersController().allManufacturers)
}

module.exports = manufacturersRoutes
