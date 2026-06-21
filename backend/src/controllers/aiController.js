const aiService = require("../services/aiService");
const jobService = require("../services/jobService");

async function prioritizeTodayJobs(req, res) {
  try {
    const jobs = await jobService.getTodayJobs();

    const aiResult = await aiService.prioritizeTodayJobs(jobs);

    return res.json({
      success: true,
      jobs,
      ai: aiResult,
    });
  } catch (error) {
    console.error("POST /api/ai/prioritize-jobs error:", error);

    return res.status(500).json({
      success: false,
      errorCode: "AI_PRIORITY_FAILED",
      message: "AI iş önceliklendirme başarısız oldu.",
    });
  }
}

module.exports = {
  prioritizeTodayJobs,
};