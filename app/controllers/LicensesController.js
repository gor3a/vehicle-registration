const mainContract = require("../../utilities/contract");
const {accounts} = require("../../utilities/accounts");

function LicensesController() {
    return {
        async allLicenses(req, res) {

            const contract = await mainContract()

            const licenses = await contract.methods.get_licenses().call((err, result) => {
                return result
            })

            const vehicles = await contract.methods.get_vehicles().call((err, result) => {
                return result
            })

            function timeConverter(UNIX_timestamp) {
                let a = new Date(parseInt(UNIX_timestamp));
                let months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                let year = a.getFullYear();
                let month = a.getMonth();
                let date = a.getDate();
                return year + '/' + month + '/' + date;
            }

            const currentUserRole = res.locals.currentUserRole

            if (currentUserRole.toString() === 'admin') {
                return res.render('licenses/list', {
                    licenses: licenses,
                    vehicles: vehicles,
                    timeConverter,
                    currentTime: Date.now(),
                })
            } else {
                const user_id = res.locals.currentUser?.user_id
                let new_licenses = []
                let new_licenses_id = []
                for (const i in licenses) {
                    if (parseInt(licenses[i].user_id) === parseInt(user_id)) {
                        new_licenses.push(licenses[i])
                        new_licenses_id.push(i)
                    }
                }

                let new_vehicles = []

                for (const license of new_licenses) {
                    new_vehicles.push(vehicles[license.car_id])
                }

                return res.render('licenses/list', {
                    licenses: new_licenses,
                    vehicles: new_vehicles,
                    timeConverter,
                    currentTime: Date.now(),
                    new_licenses_id
                })
            }
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

        async renewal(req, res) {
            const license_id = req.params.id
            const expire_at = req.params.expire_at
            const allAccounts = await accounts()

            const contract = await mainContract()

            const aYearFromNow = new Date(parseInt(expire_at));
            aYearFromNow.setFullYear(new Date().getFullYear() + 5);

            const new_expire_at = aYearFromNow.getTime().toString()

            await contract.methods.renewal_license(license_id, new_expire_at).send({
                from: allAccounts[0],
                gas: 200000000
            })

            req.flash('success', "Renewal Successfully!");

            res.redirect("/licenses")
        }
    }
}

module.exports = LicensesController
