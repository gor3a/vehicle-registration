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
            0,
            "Kia Picanto",
            "Hatchback",
            "Picanto",
            "47841564866",
            "48686",
            "red",
            "2017",
            false,
            7
        ).send({
            from: allAccounts[0],
            gas: 200000000
        })
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
            7
        ).send({
            from: allAccounts[1],
            gas: 200000000
        })
        await contract.methods.add_vehicle(
            2,
            "Jepp Cherokee",
            "Hatchback",
            "Cherokee",
            "61213261",
            "2313123",
            "Yello",
            "2022",
            false,
            7
        ).send({
            from: allAccounts[2],
            gas: 200000000
        })
        await contract.methods.add_vehicle(
            3,
            "Jepp Cx5",
            "Hatchback",
            "Cx5",
            "21321321",
            "34563464",
            "Silver",
            "2021",
            false,
            7
        ).send({
            from: allAccounts[3],
            gas: 200000000
        })
        await contract.methods.add_vehicle(
            4,
            "Fiat 128",
            "Sedan",
            "128",
            "213123123",
            "1231231",
            "White",
            "1975",
            false,
            8
        ).send({
            from: allAccounts[4],
            gas: 200000000
        })
        await contract.methods.add_vehicle(
            5,
            "Honda Hrv",
            "Hatchback",
            "Hrv",
            "2543671",
            "21315131",
            "White",
            "2022",
            false,
            8
        ).send({
            from: allAccounts[5],
            gas: 200000000
        })
        await contract.methods.add_vehicle(
            6,
            "Hyundai Verna",
            "Sedan",
            "Verna",
            "5228134213",
            "121324153421",
            "White",
            "2022",
            false,
            8
        ).send({
            from: allAccounts[6],
            gas: 200000000
        })
        await contract.methods.add_vehicle(
            7,
            "Dodge Ram",
            "Sedan",
            "Ram",
            "213213213",
            "543653542",
            "White",
            "2018",
            false,
            8
        ).send({
            from: allAccounts[7],
            gas: 200000000
        })
    }
}

module.exports = installVehicles
