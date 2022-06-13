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


homeRoutes(app)
userRoutes(app)
vehiclesRoutes(app)

// catch 404 and forward to error handler
// app.use(function (req, res, next) {
//     next(createError(404));
// });

app.use((req, res) => {
    res.status(404).render('404')
})

// error handler
app.use(function (err, req, res, next) {
    // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get('env') === 'development' ? err : {};

    // render the error page
    res.status(err.status || 500);
    next()
});

module.exports = app;
