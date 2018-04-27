var mysql = require("mysql");
require("dotenv").config();
details = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
};

var connection = mysql.createConnection(details);

connection.connect();
connection.query("SELECT 1 + 1 AS solution", function(err, results, fields) {
    if (err) {
        console.log("There is an error in the database connection");
        throw err;
    } else {
        /*emailaddr = "hp@magic.co";
        connection.query(
            "SELECT password from user where email_address = ?",
            [emailaddr],
            function(err, results, fields) {
                //there was a problem with the query or db connection
                if (err) {
                    console.log(
                        "There was a problem when trying to login, wrong mysql query"
                    );
                    done(err);
                }

                //The email address doesn't exist
                if (results.length === 0) {
                    done(null, false);
                }

                const hash = results[0].password.toString();
                //check if the user provided is the same, we're asuming that the email address is in the database
                console.log(results);
                console.log(results[0].id_user);
                console.log(hash);
            }
        );*/
        /*email_address = "hp@magic.co";
        connection.query(
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

                //res.render("./users/ok_create", {
                //    status: "Singup Complete"
                // }); //Changed for the view of registration complete
            }
        );*/
        console.log("The solution is: ", results[0].solution);
        console.log("DB Connection Okay ");
    }
});
module.exports = connection;
