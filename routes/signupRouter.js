const express = require("express");
const router = express.Router();

/* GET SignUp Page home page. */
router.get("/", function(req, res, next) {
    res.render("signup");
});

router.post("/", function(req, res, next) {
    console.log("post To SignUp save this in the db");
});

module.exports = router;
