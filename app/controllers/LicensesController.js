const mainContract = require("../../utilities/contract");

function LicensesController() {
    return {
        async allLicenses(req, res) {

            const contract = await mainContract()

            const licenses = await contract.methods.get_licenses().call((err, result) => {
                return result
            })

            const user_id = res.locals.currentUser?.user_id
            let new_licenses = []
            for (const license of licenses) {
                if (parseInt(license.user_id) === parseInt(user_id)) new_licenses.push(license)
            }
            res.render('licenses/list', {
                licenses: new_licenses
            })
        },

        async add(req, res) {
            const contract = await mainContract()

            const vehicles = await contract.methods.get_vehicles().call((err, result) => {
                return result
            })

            const user_id = res.locals.currentUser?.user_id
            let new_vehicles = []
            for (const vehicle of vehicles) {
                if (parseInt(vehicle.user_id) === parseInt(user_id)) new_vehicles.push(vehicle)
            }

            res.render('licenses/add', {
                vehicles: new_vehicles
            })
        },
        renewal(req, res) {

        }
    }
}

module.exports = LicensesController
