const express = require("express");
const router = express.Router();

/* GET home page. */
router.get("/", function(req, res, next) {
    res.render("login");
});

router.post("/", function(req, res, next) {
    console.log("Haz Hecho un post to Login");
    console.log(req.params);
    next;
});

module.exports = router;
