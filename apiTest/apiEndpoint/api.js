const express = require("express");
const bodyParser = require("body-parser");
const app = express();

app.use(bodyParser.json());

app.post("/api/endpoint", (req, res) => {
  const requestData = req.body;
  console.log(requestData);
  res.json(requestData);
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
