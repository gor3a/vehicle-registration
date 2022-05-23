const UsersController = require("../app/controllers/UsersController");

const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
const VehicleSystem = require('../build/contracts/VehicleSystem.json');

// const noty = require("noty");

const con_address = "0x38D81CB007C028cA0183BBCC19baeA79d4BEc670"
const userAddress = "0x238E69F87AC13844C8E61112996b00aFee83B3fa"

function userRoutes(app) {

    app.get("/signup", UsersController().signup)
    app.post("/signup", async function (req, res, next) {
        let abi = VehicleSystem["abi"]
        const contract = new web3.eth.Contract(abi, con_address);

        const full_name = req.body.full_name
        const email = req.body.email
        const national_id = req.body.national_id
        const phone = req.body.phone
        const password = req.body.password
        const confirm_password = req.body.confirm_password

        await contract.methods.register(userAddress, 1, full_name, email, password, "male", "2022-5-2", "Cairo", national_id, "64686", 1).send({from: userAddress, gas: 20000000}, function (error, result) {
            console.log(result, error)
            res.redirect("/")
        })
    })

    app.get("/login", UsersController().login)

    app.post("/login", async function (req, res, next) {
        let abi = VehicleSystem["abi"]
        const contract = new web3.eth.Contract(abi, con_address);

        const email = req.body.email
        const password = req.body.password
        console.log(email, password)
        await contract.methods.login(email, password).call(function (error, result) {
            console.log(result)
            if (!result) {
                res.redirect("/login")
            } else {
                res.redirect("/")
            }
        })
    })
}

module.exports = userRoutes;
