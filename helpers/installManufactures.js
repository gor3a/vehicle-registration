const mainContract = require("../utilities/contract");
const {accounts} = require("../utilities/accounts");

async function installManufactures() {
    const contract = await mainContract()
    const allAccounts = await accounts()

    const manufactures_length = await contract.methods.manufactures_length().call((err, result) => {
        return result
    })


    if (!parseInt(manufactures_length)) {
        await contract.methods.add_manufacture(0, "Kia").send({
            from: allAccounts[0],
            gas: 200000000
        })
        await contract.methods.add_manufacture(1, "BMW").send({
            from: allAccounts[1],
            gas: 200000000
        })
    }
}

module.exports = installManufactures
