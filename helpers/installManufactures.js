const mainContract = require("../utilities/contract");
const {accounts} = require("../utilities/accounts");

async function installManufactures() {
    const contract = await mainContract()
    const allAccounts = await accounts()

    const manufactures_length = await contract.methods.manufactures_length().call((err, result) => {
        return result
    })

    if (!parseInt(manufactures_length)) {
        await contract.methods.add_manufacture(5, "Kia").send({
            from: allAccounts[5],
            gas: 200000000
        })
        await contract.methods.add_manufacture(5, "BMW").send({
            from: allAccounts[5],
            gas: 200000000
        })
        await contract.methods.add_manufacture(5, "Jeep").send({
            from: allAccounts[5],
            gas: 200000000
        })
        await contract.methods.add_manufacture(5, "Mazda").send({
            from: allAccounts[5],
            gas: 200000000
        })
        await contract.methods.add_manufacture(6, "Fiat").send({
            from: allAccounts[6],
            gas: 200000000
        })
        await contract.methods.add_manufacture(6, "Honda").send({
            from: allAccounts[6],
            gas: 200000000
        })
        await contract.methods.add_manufacture(6, "Hyundai").send({
            from: allAccounts[6],
            gas: 200000000
        })
        await contract.methods.add_manufacture(6, "Dodge").send({
            from: allAccounts[6],
            gas: 200000000
        })

    }
}

module.exports = installManufactures
