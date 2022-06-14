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
                    await contract.methods.get_user(parseInt(result)).call(function (error, userResult) {
                        req.session.user = {
                            user_id: parseInt(result),
                            user_address: userResult.user_address,
                            user_name: userResult.user_name,
                            user_email: userResult.user_email,
                            user_password: userResult.user_password,
                            user_phone: userResult.user_phone,
                            user_national_id: userResult.user_national_id,
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


            await contract.methods.register(userAddress, full_name, email, phone, password, national_id, 0).send({
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
        async users(req, res) {
            const contract = await mainContract()

            const users = await contract.methods.get_users().call(function (err, result) {
                return result
            })

            res.render("user/list", {
                users
            })
        },
        async profile(req, res) {
            res.render("user/profile", {
                user: req.session.user
            })
        },
        async profilePost(req, res) {
            const contract = await mainContract()

            req.checkBody("phone").notEmpty()
            req.checkBody("password").notEmpty().isLength({min: 8})
            req.checkBody("confirm_password").notEmpty().equals(req.body.password)

            let errors = req.validationErrors();
            if (errors) {
                return res.send(JSON.stringify({
                    "message": errors,
                }));
            }

            const phone = req.body.phone
            const password = req.body.password

            req.session.user.user_phone = phone
            req.session.user.user_password = password

            await contract.methods.edit_user(req.session.user.user_id, phone, password).send({
                from: req.session.user.user_address,
                gas: 200000000
            })

            res.redirect("/profile")
        }
    }
}

module.exports = UsersController
