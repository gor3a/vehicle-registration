function VehiclesController() {
    return {
        allVehicles(req, res, next) {
            res.render("vehicles/list")
        },
        addVehicle(req, res, next) {
            res.render("vehicles/add")
        },
        addVehiclePost(req, res, next) {

        },
        editVehicle(req, res, next) {

        },
        editVehiclePost(req, res, next) {

        },
    }
}

module.exports = VehiclesController
