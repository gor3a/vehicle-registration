const VehiclesController = require("../app/controllers/VehiclesController");
const auth = require("../app/middlewares/auth");

function vehiclesRoutes(app) {
    app.get("/vehicles", auth, VehiclesController().allVehicles)

    app.get("/vehicles/add", auth, VehiclesController().addVehicle)
    app.post("/vehicles/add", auth, VehiclesController().addVehiclePost)

    app.get("/vehicles/edit/{id}", auth, VehiclesController().editVehicle)
    app.post("/vehicles/edit/{id}", auth, VehiclesController().editVehiclePost)
}

module.exports = vehiclesRoutes
