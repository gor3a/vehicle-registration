const mainContract = require("../../utilities/contract");

function ManufacturersController() {
    return {
        async allManufacturers(req, res, next) {
            const contract = await mainContract()
            let users = []
            let manufactures = await contract.methods.get_manufactures().call(async function (err, result) {
                return result
            })

            for (const i in manufactures) {
                const user = await contract.methods.get_user(manufactures[i].user_id).call((err, result) => {
                    return result
                })
                manufactures[i].user = user
                users.push(user)
            }

            res.render("manufacturers/list", {
                manufactures, users
            })
        }
    }
}

module.exports = ManufacturersController
