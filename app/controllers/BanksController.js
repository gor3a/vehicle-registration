const mainContract = require("../../utilities/contract");

function BanksController() {
    return {
        async allBanks(req, res, next) {

            const contract = await mainContract()
            let users = []
            let banks = await contract.methods.get_banks().call(async function (err, result) {
                return result
            })

            for (const i in banks) {
                const user = await contract.methods.get_user(banks[i].user_id).call((err, result) => {
                    return result
                })
                banks[i].user = user
                users.push(user)
            }

            res.render("banks/list", {
                banks, users
            })
        }
    }
}

module.exports = BanksController
