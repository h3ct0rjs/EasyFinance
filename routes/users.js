var express = require("express");
var router = express.Router();

/* GET Default Page. */
// /user
router.get("/", function(req, res, next) {
    res.send("respond with a resource");
});

// /user/id:/dashboard/
router.get(":id/dashboard", function(req, res, next) {
    res.send("You're in the dashboard " + req.params.id);
});

// /user/id:/dashboard/
router.get("/dashboard/", function(req, res, next) {
    //preguntar si el usuario esta autenticado
    res.render("index2");
});

module.exports = router;
