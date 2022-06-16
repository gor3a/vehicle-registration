const mainContract = require("../utilities/contract");
const {accounts} = require("../utilities/accounts");

async function installBanks() {
    const contract = await mainContract()
    const allAccounts = await accounts()

    const banks_length = await contract.methods.banks_length().call((err, result) => {
        return result
    })

    if (!parseInt(banks_length)) {
        await contract.methods.add_bank(3, "Banque Misr").send({
            from: allAccounts[3],
            gas: 200000000
        })
        await contract.methods.add_bank(4, "CIB").send({
            from: allAccounts[4],
            gas: 200000000
        })
    }
}

module.exports = installBanks
