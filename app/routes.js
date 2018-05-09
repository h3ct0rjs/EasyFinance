/*URLS Action endpoints
	www.easyf.co/										[get]	:Done
				about/  								[get]	:Done
	 			users/ 									[redirect] :Done
		  			login/								[get, post]:Done
					signup/								[get, post]
					dashboard/							[get, post]
							 profile/ 					[get, post, delete]
							 	settings				[get, post]
							 accounts/					[get, post, delete, put]
		  	          	     	savings					[get, post, delete, put]
							 	current					[get, post, delete, put]
							 	loan					[get, post, delete, put]
							 analitics/					[get]
							 investments/				[get, post]
							 budgets/					[get, post]
							 cryptomoney/				[get, post]
	*/

// app/routes.js
const mysql = require("mysql");
var dbconfig = require("../config/database");
var connection = mysql.createConnection(dbconfig.connection);
connection.query("USE " + dbconfig.database);
//connection.query("USE " + dbconfig.database);

module.exports = function(app, passport) {
	// =====================================
	// HOME PAGE
	// =====================================
	app.get("/", function(req, res) {
		res.render("index"); // load the index.ejs file
	});

	// =====================================
	// LOGIN
	// =====================================
	app.get("/users/login", function(req, res) {
		// render the page and pass in any flash data if it exists
		res.render("./user/login", {
			message: req.flash("loginMessage")
		});
	});

	app.post(
		"/users/login",
		passport.authenticate("local-login", {
			successRedirect: "/users/dashboard", // redirect to the secure profile section
			failureRedirect: "/users/login", // redirect back to the signup page if there is an error
			failureFlash: true // allow flash messages
		}),
		function(req, res) {
			console.log("hello");

			if (req.body.remember) {
				req.session.cookie.maxAge = 1000 * 60 * 3;
			} else {
				req.session.cookie.expires = false;
			}
			res.redirect("/");
		}
	);

	// =====================================
	// SIGNUP
	// =====================================
	app.get("/users/signup", function(req, res) {
		// render the page and pass in any flash data if it exists
		res.render("./user/signup", {
			message: req.flash("signupMessage")
		});
	});

	// process the signup form
	app.post(
		"/users/signup",
		passport.authenticate("local-signup", {
			successRedirect: "/users/login", // redirect to the secure profile section
			failureRedirect: "/users/signup", // redirect back to the signup page if there is an error
			failureFlash: true // allow flash messages
		})
	);

	// =====================================
	// PROFILE SECTION
	// =====================================
	app.get("/users/profile", isLoggedIn, function(req, res) {
		res.render("./user/profile", {
			user: req.user // get the user out of session and pass to template
		});
	});

	// =====================================
	// DASHBOARD SECTION
	// =====================================
	app.get("/users/dashboard", isLoggedIn, function(req, res) {
		//carga parcial de datos de usuario balances, foto de perfil....etc
		res.render("./user/dashboard/main", {
			//add more logic here!
			user: req.user // get the user out of session and pass to template
		});
	});

	//Show all routes
	app.get("/users/dashboard/account", isLoggedIn, function(req, res) {
		res.render("./user/dashboard/", {
			//add more logic here!
			user: req.user // get the user out of session and pass to template
		});
	});

	app.get("/users/dashboard/add_account", isLoggedIn, function(req, res) {
		res.render("./user/dashboard/addaccount", {
			//add more logic here!
			user: req.user, // get the user out of session and pass to template
			title: "Add an Account"
		});
	});

	app.post("/users/dashboard/add_account", isLoggedIn, function(req, res) {
		//req ! ademas insert into las bases datos
		//console.log(req);
		data = {
			account_number: req.body.account_number,
			date: req.body.dateaccount
		};
		if (req.body.selectpicker === "Savings") data.account_type = "saving";
		if (req.body.selectpicker === "Credit") data.account_type = "credit";
		if (req.body.selectpicker === "Current") data.account_type = "current";
		if (req.body.selectbank === "Banco1") data.bank = 1;
		console.log(data);
		console.log(req.user);
		var insertQuery =
			"INSERT INTO account (id_bank, id, id_currency, number_acc, state_acc, type_acc) VALUES (?,?,?,?,?,?)";
		connection.query(
			insertQuery,
			[
				data.bank,
				req.user.id,
				1,
				data.account_number,
				true,
				data.account_type
			],
			function(err, rows) {
				if (err) {
					console.log("Wrong Insert Buuuuuuuuuu");
					throw err;
				}

				data.id = rows.insertId;
				res.render("./user/dashboard/addaccount", {
					//add more logic here!
					user: req.user, // get the user out of session and pass to template
					title: "Done,Account Added!"
				});
			}
		);
	});

	app.get("/users/dashboard/accounts/credit", isLoggedIn, function(req, res) {
		console.log(req.user);
	});

	app.get("/users/dashboard/accounts/current", isLoggedIn, function(
		req,
		res
	) {
		res.render("./user/dashboard/credit", {
			//add more logic here!
			user: req.user, // get the user out of session and pass to template
			title: "Add an Account"
		});
	});

	app.get("/users/dashboard/accounts/savings", isLoggedIn, function(
		req,
		res
	) {
		res.render("./user/dashboard/credit", {
			//select name_bank,number_acc,type_acc from account,user,bank where user.id = 2 and bank.id_bank = 1;
			//add more logic here!
			user: req.user, // get the user out of session and pass to template
			title: "Add an Account"
		});
	});

	// =====================================
	// LOGOUT
	// =====================================
	app.get("/users/logout", function(req, res) {
		req.logout();
		res.redirect("/users/login");
	});
};

// route middleware to make sure
function isLoggedIn(req, res, next) {
	// if user is authenticated in the session, carry on
	if (req.isAuthenticated()) return next();
	// if they aren't redirect them to the home page
	res.redirect("/users/login");
}
