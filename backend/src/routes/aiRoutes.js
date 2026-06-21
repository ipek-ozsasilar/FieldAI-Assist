const express = require("express");
const aiController = require("../controllers/aiController");

const router = express.Router();

router.post("/prioritize-jobs", aiController.prioritizeTodayJobs);

module.exports = router;