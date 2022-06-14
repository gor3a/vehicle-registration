const mainContract = require("../utilities/contract");
const {accounts} = require("../utilities/accounts");

async function installUsers() {
    const contract = await mainContract()
    const allAccounts = await accounts()

    const users_length = await contract.methods.users_length().call((err, result) => {
        return result
    })

    if (!parseInt(users_length)) {
        await contract.methods.register(allAccounts[0], "Mina Sameh", "mina.sameh.lameh@gmail.com", "01271191820", "123456789", "30001004898", 3).send({
            from: allAccounts[0],
            gas: 200000000
        })
        await contract.methods.register(allAccounts[1], "Suhila Khaled", "suhila.khaled@gmail.com", "13213", "123456789", "21321321", 3).send({
            from: allAccounts[1],
            gas: 200000000
        })
    }
}

module.exports = installUsers
