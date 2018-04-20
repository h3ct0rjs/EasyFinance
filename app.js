const createError = require("http-errors");
const express = require("express");
const session = require("express-session"); //How to solve sessions
const path = require("path");
const cookieParser = require("cookie-parser");
const logger = require("morgan");
const passport = require("passport");
const flash = require("connect-flash");

//Routes
var indexRouter = require("./routes/index");
var usersRouter = require("./routes/users");
var signupRouter = require("./routes/signupRouter");
var loginRouter = require("./routes/loginRouter");
var aboutRouter = require("./routes/about");
var recover = require("./routes/recover");

var app = express();
// view engine setup
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser()); //using cookies :)
app.use(express.static(path.join(__dirname, "public")));
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));

app.use(
    session({
        secret: "laboratoriodesoftware2018",
        resave: true,
        saveUninitialized: true
    })
); // session secret

app.use(passport.initialize());
app.use(passport.session()); // persistent login sessions
app.use(flash()); // use connect-flash for flash messages stored in session

//Routes
app.use("/", indexRouter);
app.use("/login", loginRouter);
app.use("/signup", signupRouter);
app.use("/recover", recover);
app.use("/about", aboutRouter);
//Protected Routes
app.use("/user", usersRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
    next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
    // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get("env") === "development" ? err : {};
    // render the error page
    res.status(err.status || 500);
    res.render("error");
});

module.exports = app;
