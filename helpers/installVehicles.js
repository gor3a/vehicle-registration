const mainContract = require("../utilities/contract");
const {accounts} = require("../utilities/accounts");

async function installVehicles() {
    const contract = await mainContract()
    const allAccounts = await accounts()

    const vehicles_length = await contract.methods.vehicles_length().call((err, result) => {
        return result
    })

    if (!parseInt(vehicles_length)) {
        await contract.methods.add_vehicle(
            1,
            "BMW X7",
            "Hatchback",
            "X7",
            "47321384866",
            "486862131",
            "black",
            "2022",
            false,
            0,
            0
        ).send({
            from: allAccounts[0],
            gas: 200000000
        })
        await contract.methods.add_vehicle(
            0,
            "Kia Picanto",
            "Hatchback",
            "Picanto",
            "4784866",
            "48686",
            "red",
            "2017",
            false,
            0,
            1
        ).send({
            from: allAccounts[1],
            gas: 200000000
        })
    }
}

module.exports = installVehicles
