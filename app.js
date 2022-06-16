const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const expressValidator = require("express-validator")
const session = require("express-session")
const expressLayout = require('express-ejs-layouts')
const flash = require('express-flash')

require('dotenv').config()

// Routes
const userRoutes = require("./routes/users");
const homeRoutes = require("./routes/home");
const vehiclesRoutes = require("./routes/vehicles");
const installUsers = require("./helpers/installUsers");
const installManufactures = require("./helpers/installManufactures");
const installVehicles = require("./helpers/installVehicles");
const licensesRoutes = require("./routes/licenses");
const manufacturersRoutes = require("./routes/manufacturers");
const banksRoutes = require("./routes/banks");
const installBanks = require("./helpers/installBanks");
const roles = require("./utilities/roles");
const installLicenses = require("./helpers/installLicenses");

const app = express();

app.use(flash())
// Global middleware
app.use((req, res, next) => {
    res.locals.session = req.session
    res.locals.user = req.user
    next()
})
// view engine setup
app.use(expressLayout)
app.set("views", path.join(__dirname, "resources/views"));
app.set("view engine", "ejs");

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use(expressValidator())
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

const oneDay = 1000 * 60 * 60 * 24;
app.use(session({
    secret: "thisismysecrctekeyfhrgfgrfrty84fwir767",
    saveUninitialized: true,
    cookie: {maxAge: oneDay},
    resave: false
}));

// init
installUsers()
installManufactures()
installVehicles()
installBanks()
installLicenses()

app.use(function (req, res, next) {
    res.locals.currentUser = req.session.user;
    res.locals.currentUserRole = roles(req.session.user?.user_role);
    res.locals.message = req.flash();
    next()
})

homeRoutes(app)
userRoutes(app)
vehiclesRoutes(app)
licensesRoutes(app)
manufacturersRoutes(app)
banksRoutes(app)

app.use((req, res) => {
    res.status(404).render('404')
})

module.exports = app;
