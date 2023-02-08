const Web3 = require("web3");

async function accounts() {
    const web3 = new Web3(new Web3.providers.HttpProvider(process.env.WEB3_PROVIDER_URL || "http://127.0.0.1:7545"));
    return await web3.eth.getAccounts()
}

async function getFirstAccount() {
    const allAccounts = await accounts()
    return allAccounts.length ? allAccounts[0] : "";
}

module.exports = {
    accounts,
    getFirstAccount
}
