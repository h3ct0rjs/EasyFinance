const express = require("express");
const expressValidator = require("express-validator");
const passport = require("passport");
const bcrypt = require("bcrypt");
const moment = require("moment");
const db = require("../db");
const saltRounds = 10;
const router = express.Router();
/* 
This are all the actions for the users module. 
www.easyfinancer.co/users/
                        login/
                        register/
                        signup>>register/                    
                        password_recovery/
                        ok_create/
                        dashboard/
                                  accounts/
                                          credits
                                           savings
                                            loan
                                   cryptobalance
                                   invesments
                                   currencyexchange
                                   analytics
*/

router.get("/login", function(req, res, next) {
    res.render("./users/login", { title: "Login" });
});

router.post(
    "/login",
    passport.authenticate("local", {
        successRedirect: "/users/dashboard",
        failureRedirect: "/users/login",
        session: false
    })
);

//Register and Signup User
//GET
router.get("/register", function(req, res, next) {
    res.render("./users/signup", { title: "SignUp" });
});

//POST
router.post("/register", function(req, res, next) {
    //Validation in the post request

    //Firstname
    req.checkBody("fname", "First Name field can't be empty").notEmpty();
    req
        .checkBody("fname", "First Name can only contain letters.")
        .matches(/^[A-Za-z ]+$/, "i");

    //Lastname
    req.checkBody("lname", "Last Name field can't be empty").notEmpty();
    req
        .checkBody("lname", "Last Name can only contain letters.")
        .matches(/^[A-Za-z ]+$/, "i");

    //Number Identification
    req
        .checkBody(
            "pid",
            "Identification field must be at least 6 numbers characters long."
        )
        .matches(/\d/);

    //Username
    //req
    //    .checkBody("username", "User Name field can't be empty")
    //    .notEmpty()

    //Email address
    req
        .checkBody("email_address", "Email Address field can't be empty")
        .notEmpty();
    req
        .checkBody(
            "email_address",
            "The email you entered is invalid, please try again."
        )
        .isEmail()
        .normalizeEmail();
    req
        .checkBody(
            "email_address",
            "Email address must be between 4-100 characters long, please try again."
        )
        .len(4, 100);

    //password
    //req
    //    .checkBody(
    //        "password",
    //        "Password must include one lowercase character, one uppercase character, a number, and a special character."
    //    )
    //    .matches(
    //        /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.* )(?=.*[^a-zA-Z0-9]).{8,}$/,
    //        "i"
    //    );
    req.checkBody("password", "Password field can't be empty").notEmpty();
    req
        .checkBody("password", "Password must be between 8-70 characters long.")
        .len(8, 70);

    //Password match
    // req
    //     .checkBody(
    //         "password_match",
    //         "Passwords do not match, please try again."
    //     )
    //     .equals(req.body.password);
    //Catch all the errors

    const errors = req.validationErrors();

    if (errors) {
        //console.log(`errors:${JSON.stringify(errors)}`);
        res.render("./users/signup", {
            title: "Signing Up with Errors",
            errors: errors
        });
    } else {
        //If there is not error in our request validation we just create all the data
        const fname = req.body.fname;
        const sname = req.body.lname;
        const username = req.body.username;
        const email_address = req.body.email_address;
        const password = req.body.password;
        data = {
            First_name: fname,
            Last_name: sname,
            Username: username,
            email_addr: email_address,
            passwordx: password
        };

        date = moment().format("YYYY-MM-DD");
        //Create the insertion and redirect to other view, password complete

        bcrypt.hash(password, saltRounds, function(err, hash) {
            //We insert the data into the database
            db.query(
                "INSERT INTO user(email_address,fname,lname,login_state,type_user, last_login, password,username) VALUES (?,?,?,?,?,?,?,?);",
                [
                    email_address,
                    fname,
                    sname,
                    0,
                    "customer",
                    date,
                    hash,
                    username
                ],
                function(err, results, fields) {
                    if (err) {
                        console.log(
                            "[!!!] Fallo al hacer el insert de registro de usuario"
                        );
                        throw err;
                    } //add here a failed register
                    console.log("YaY!, Insert OK");

                    db.query(
                        "SELECT * from user where email_address = ?",
                        [email_address],
                        function(error, results, fields) {
                            console.log(results[0]);
                            console.log("------------");
                            //0428, 956 clase A
                            //If there is a problem retrieving the last id created in db
                            if (error) throw error;
                            const user_id = results[0].id_user;
                            console.log(
                                `Id de usuario despues de obtener la getid de la db : ${user_id}`
                            );

                            res.render("./users/ok_create", {
                                status: "Singup Complete"
                            }); //Changed for the view of registration complete
                        }
                    );
                }
            ); //end of  Insert Into
        }); //end of bcryptjs
    }

    // Configure Passport authenticated session persistence.
    //
    // In order to restore authentication state across HTTP requests, Passport needs
    // to serialize users into and deserialize users out of the session.  The
    // typical implementation of this is as simple as supplying the user ID when
    // serializing, and querying the user record by ID from the database when
    // deserializing.
    passport.serializeUser(function(user_id, done) {
        done(null, user_id);
    });

    passport.deserializeUser(function(user_id, done) {
        done(null, user_id);
    });
});

//Recovery
router.get("/password_recovery", function(req, res, next) {
    console.log("[*****] Password Recovery");
    console.log(req.user);
    console.log(req.isAuthenticated());
    res.render("./users/recover_password", { title: "Password Recovery" });
});

router.post("/password_recovery", function(req, res, next) {
    res.render("./users/recover_password", { title: "Password Recovery" });
});

router.get("/ok_create", function(req, res, next) {
    console.log("[*****] After Creating the account");
    console.log(req.user);
    console.log(req.isAuthenticated());

    res.render("./users/ok_create", {
        status: "Okay your account has been created ✓"
    });
});

router.get("/dashboard", authMiddleware(), function(req, res, next) {
    console.log("[*****] Authentication Dashboard");
    console.log(req.user);
    console.log(req.isAuthenticated());
    res.render("./users/dashboard/main", {
        status: "Okay your account has been created ✓"
    });
});

//Protected Routes with passport
router.get("/profile", authMiddleware(), function(req, res, next) {
    console.log("We're in the Profile Section");
    res.render("dummy", { title: "Profile Section" });
});

router.get("/test", function(req, res, next) {
    console.log("************************");
    res.render("dummy", { title: "Test Page" });
});
//restrict access
function authMiddleware() {
    return (req, res, next) => {
        console.log(
            `req.session.passport.user: ${JSON.stringify(req.session.passport)}`
        );

        if (req.isAuthenticated()) return next();
        console.log(
            "Youre not authenticated, you're being redirected to the login page"
        );
        res.redirect("/users/login");
    };
}

//Interception of ghost urls adaptable to american standard
router.get("/signup", function(req, res, next) {
    res.redirect("/users/register");
});

router.get("/", function(req, res, next) {
    res.redirect("/users/login");
});
module.exports = router;
