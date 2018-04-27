const express = require("express");
const expressValidator = require("express-validator");
const router = express.Router();
/* GET home page. */
router.get("/", function(req, res, next) {
    console.log("[*****] Root Authentication");
    console.log(req.user);
    console.log(req.isAuthenticated());
    res.render("index", { title: "Index" });
});

module.exports = router;
