const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
const VehicleSystem = require('../../build/contracts/VehicleSystem.json');

function UsersController() {

    return {
        login(req, res, next) {
            res.render('user/login')
        },
        signup(req, res, next) {
            res.render('user/signup')
        },
    }
}

module.exports = UsersController
