const mainContract = require("../../utilities/contract");
const {getFirstAccount} = require("../../utilities/accounts");

function UsersController() {

    return {
        async login(req, res, next) {
            return res.render('user/login')
        },
        async loginPost(req, res, next) {
            const contract = await mainContract()

            const email = req.body.email
            const password = req.body.password

            console.log(email, password)

            await contract.methods.login(email, password).call(async function (error, result) {
                console.log(result, typeof result)
                if (parseInt(result) === -1) {
                    res.redirect("/login")
                } else {
                    await contract.methods.get_user(parseInt(result)).call(function (error, result) {
                        req.session.user = {
                            user_address: result.user_address,
                            user_name: result.user_name,
                            user_email: result.user_email,
                            user_password: result.user_password,
                            user_phone: result.user_phone,
                            user_national_id: result.user_national_id,
                        }
                    })
                    res.redirect("/")
                }
            })
        },
        signup(req, res, next) {
            res.render('user/signup')
        },
        async signupPost(req, res, next) {
            const contract = await mainContract()
            let userAddress = await getFirstAccount()

            req.checkBody("full_name").notEmpty()
            req.checkBody("email").notEmpty().isEmail()
            req.checkBody("national_id").notEmpty()
            req.checkBody("phone").notEmpty()
            req.checkBody("password").notEmpty().isLength({min: 8})
            req.checkBody("confirm_password").notEmpty().equals(req.body.password)

            let errors = req.validationErrors();
            if (errors) {
                return res.send(JSON.stringify({
                    "message": errors,
                }));
            }

            const full_name = req.body.full_name
            const email = req.body.email
            const national_id = req.body.national_id
            const phone = req.body.phone
            const password = req.body.password


            await contract.methods.register(userAddress, full_name, email, phone, password, national_id).send({
                from: userAddress,
                gas: 200000000
            }, function (error, result) {
                console.log(result, error)
                res.redirect("/")
            })
        },
        logout(req, res) {
            delete req.session.user
            res.redirect("/")
        },
        users(req, res) {
            res.render("user/list")
        },
        profile(req, res) {
            res.render("user/profile")
        },
        profilePost(req, res) {

        }
    }
}

module.exports = UsersController
