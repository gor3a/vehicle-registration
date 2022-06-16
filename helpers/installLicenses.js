const mainContract = require("../utilities/contract");
const {accounts} = require("../utilities/accounts");

async function installLicenses() {
    const contract = await mainContract()
    const allAccounts = await accounts()

    const licenses_length = await contract.methods.licenses_length().call((err, result) => {
        return result
    })

    if (!parseInt(licenses_length)) {
        await contract.methods.add_license(7, 0, "1652661749000").send({
            from: allAccounts[7],
            gas: 200000000
        })
        await contract.methods.add_license(7, 1, "958437749000").send({
            from: allAccounts[7],
            gas: 200000000
        })
        await contract.methods.add_license(7, 2, "1835656949000").send({
            from: allAccounts[7],
            gas: 200000000
        })
        await contract.methods.add_license(7, 3, "1415148149000").send({
            from: allAccounts[7],
            gas: 200000000
        })
        await contract.methods.add_license(8, 4, "1765759349000").send({
            from: allAccounts[8],
            gas: 200000000
        })
        await contract.methods.add_license(8, 5, "1285375349000").send({
            from: allAccounts[8],
            gas: 200000000
        })
        await contract.methods.add_license(8, 6, "1717548149000").send({
            from: allAccounts[8],
            gas: 200000000
        })
        await contract.methods.add_license(8, 7, "1662338549000").send({
            from: allAccounts[8],
            gas: 200000000
        })
    }
}

module.exports = installLicenses
