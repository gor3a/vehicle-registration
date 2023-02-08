const mainContract = require("../../utilities/contract");

function VehiclesController() {
    return {
        async allVehicles(req, res, next) {
            const contract = await mainContract()

            const vehicles = await contract.methods.get_vehicles().call((err, result) => {
                return result
            })

            const currentUserRole = res.locals.currentUserRole

            console.log(currentUserRole.toString() === 'admin')

            if (currentUserRole.toString() === 'admin') {
                return res.render("vehicles/list", {
                    vehicles
                })
            } else {
                const user_id = res.locals.currentUser?.user_id
                let new_vehicles = []
                let new_vehicles_id = []
                for (const i in vehicles) {
                    if (parseInt(vehicles[i].user_id) == parseInt(user_id)) {
                        new_vehicles.push(vehicles[i])
                        new_vehicles_id.push(i)
                    }
                }
                return res.render("vehicles/list", {
                    vehicles: new_vehicles,
                    vehicles_id: new_vehicles_id
                })
            }
        },
        addVehicle(req, res, next) {
            res.render("vehicles/add")
        },
        async addVehiclePost(req, res, next) {
            const contract = await mainContract()

            req.checkBody("vehicle_name").notEmpty()
            req.checkBody("vehicle_model").notEmpty()
            req.checkBody("vehicle_type").notEmpty()
            req.checkBody("vehicle_production_year").notEmpty()
            req.checkBody("vehicle_motor_number").notEmpty()
            req.checkBody("vehicle_chassis_number").notEmpty()
            req.checkBody("vehicle_color").notEmpty()
            req.checkBody("owner_address").notEmpty()

            let errors = req.validationErrors();
            if (errors) {
                return res.send(JSON.stringify({
                    "message": errors,
                }));
            }

            const vehicle_name = req.body.vehicle_name
            const vehicle_model = req.body.vehicle_model
            const vehicle_type = req.body.vehicle_type
            const vehicle_production_year = req.body.vehicle_production_year
            const vehicle_motor_number = req.body.vehicle_motor_number
            const vehicle_chassis_number = req.body.vehicle_chassis_number
            const vehicle_color = req.body.vehicle_color
            const owner_address = req.body.owner_address

            await contract.methods.add_vehicle(
                1,
                vehicle_name,
                vehicle_type,
                vehicle_model,
                vehicle_motor_number,
                vehicle_chassis_number,
                vehicle_color,
                vehicle_production_year,
                false,
                0
            ).send({
                from: owner_address,
                gas: 200000000
            })
            req.flash('success', "Added Successfully!");
            res.redirect("/vehicles")
        },
        async editVehicle(req, res, next) {
            const vehicle_id = req.params.id
            const contract = await mainContract()

            const vehicle = await contract.methods.get_vehicle(vehicle_id).call((err, result) => {
                return result
            })

            const user = await contract.methods.get_user(vehicle.user_id).call((err, result) => {
                return result
            })

            res.render("vehicles/add", {
                page: req.url,
                vehicle: vehicle,
                user: user,
            })
        },
        async editVehiclePost(req, res, next) {

            const contract = await mainContract()
            const vehicle_id = req.params.id

            req.checkBody("owner_address").notEmpty()
            req.checkBody("vehicle_color").notEmpty()

            const owner_address = req.body.owner_address
            const vehicle_color = req.body.vehicle_color

            const newOwner = await contract.methods.get_user_id_with_address(owner_address).call((err, result) => {
                return result;
            })

            await contract.methods.edit_vehicle(
                vehicle_id,
                newOwner,
                vehicle_color
            ).send({
                from: owner_address,
                gas: 200000000
            })

            req.flash('success', "Updated Successfully!");
            res.redirect("/vehicles/edit/" + vehicle_id)

        },
    }
}

module.exports = VehiclesController
