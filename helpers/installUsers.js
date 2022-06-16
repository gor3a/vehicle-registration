const mainContract = require("../utilities/contract");
const {accounts} = require("../utilities/accounts");

async function installUsers() {
    const contract = await mainContract()
    const allAccounts = await accounts()

    const users_length = await contract.methods.users_length().call((err, result) => {
        return result
    })

    if (!parseInt(users_length)) {

        // Admins
        await contract.methods.register(allAccounts[0], "Dr Mohamed Sameh", "dr.mohamed.sameh@gmail.com", "13213", "123456789", "21321321", 3).send({
            from: allAccounts[0], gas: 200000000
        })
        await contract.methods.register(allAccounts[1], "Dr Osama Emam", "dr.osama.emam@gmail.com", "13213", "123456789", "21321321", 3).send({
            from: allAccounts[1], gas: 200000000
        })
        await contract.methods.register(allAccounts[2], "Mina Sameh", "mina.sameh@gmail.com", "01271191820", "123456789", "30001004898", 3).send({
            from: allAccounts[2], gas: 200000000
        })

        // Banks
        await contract.methods.register(allAccounts[3], "Suhila Khaled", "suhila.khaled@gmail.com", "13213", "123456789", "21321321", 2).send({
            from: allAccounts[3], gas: 200000000
        })
        await contract.methods.register(allAccounts[4], "Hager Soliman", "hager.soliman@gmail.com", "13213", "123456789", "21321321", 2).send({
            from: allAccounts[4], gas: 200000000
        })

        // Manufacturer
        await contract.methods.register(allAccounts[5], "Adham Hashim", "adham.hashim@gmail.com", "13213", "123456789", "21321321", 1).send({
            from: allAccounts[5], gas: 200000000
        })

        await contract.methods.register(allAccounts[6], "George Youssef", "george.youssef@gmail.com", "13213", "123456789", "21321321", 1).send({
            from: allAccounts[6], gas: 200000000
        })

        // Users
        await contract.methods.register(allAccounts[7], "Ahmed Badr", "ahmed.badr@gmail.com", "13213", "123456789", "21321321", 0).send({
            from: allAccounts[7], gas: 200000000
        })
        await contract.methods.register(allAccounts[7], "Youssef Mahmoud", "youssef.mahmoud@gmail.com", "13213", "123456789", "21321321", 0).send({
            from: allAccounts[8], gas: 200000000
        })

    }
}

module.exports = installUsers
