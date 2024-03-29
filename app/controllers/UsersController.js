const mainContract = require("../../utilities/contract");
const {getFirstAccount, accounts} = require("../../utilities/accounts");

function UsersController() {

    return {
        async login(req, res, next) {
            return res.render('user/login')
        },
        async loginPost(req, res, next) {
            const contract = await mainContract()

            const email = req.body.email
            const password = req.body.password

            await contract.methods.login(email, password).call(async function (error, result) {
                if (parseInt(result) === -1) {
                    req.flash('error', "Wrong credentials");
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
                            user_role: userResult.role
                        }
                    })
                    req.flash('success', "Login Successfully");
                    res.redirect("/")
                }
            })
        },
        signup(req, res, next) {
            res.render('user/signup')
        },
        async signupPost(req, res, next) {
            const contract = await mainContract()
            const allAccounts = await accounts()
            let userAddress = await getFirstAccount()

            req.checkBody("full_name").notEmpty()
            req.checkBody("email").notEmpty().isEmail()
            req.checkBody("national_id").notEmpty()
            req.checkBody("phone").notEmpty()
            req.checkBody("public_address").notEmpty()
            req.checkBody("password").notEmpty().isLength({min: 8})
            // req.checkBody("confirm_password").notEmpty().equals(req.body.password)

            let errors = req.validationErrors();
            if (errors) {
                // return res.send(JSON.stringify({
                //     "message": errors,
                // }));
                req.flash('error', "Error happened when try to signup");
                res.redirect("/signup")
            }

            const full_name = req.body.full_name
            const email = req.body.email
            const national_id = req.body.national_id
            const phone = req.body.phone
            const password = req.body.password
            const public_address = req.body.public_address

            if(allAccounts.indexOf(public_address) == -1) {
                req.flash('error', "Public Adddress not found");   
                return res.redirect("/signup")
            }

            await contract.methods.register(public_address, full_name, email, phone, password, national_id, 0).send({
                from: public_address,
                gas: 200000000
            })

            req.flash('success', "Signup Successfully!");
            res.redirect("/")
        },
        logout(req, res) {
            delete req.session.user
            req.flash('success', "Logout Successfully!");
            res.redirect("/")
        },
        async profile(req, res) {
            res.render("user/profile", {
                user: req.session.user
            })
        },
        async users(req, res) {
            const contract = await mainContract()

            const users = await contract.methods.get_users().call(function (err, result) {
                return result
            })

            const roles = require("../../utilities/roles")
            const capitalize = require("../../utilities/capitalize")

            res.render("user/list", {
                users,
                roles,
                capitalize
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

            req.flash('success', "Updated Successfully!");
            res.redirect("/profile")
        }
    }
}

module.exports = UsersController
