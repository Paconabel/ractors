const express = require("express");
const app = express();
const port = 3000;

function rnd(min, max) {
  return Math.floor(Math.random() * (max - min + 1) + min);
}

app.get("/transfer/*", (request, response) => {
  setTimeout(() => {
    response.send({ amount: rnd(1000, 3000) });
  }, rnd(100, 500));
});

app.listen(3000, (err) => {
  console.log(`Server is listening on ${port}`);
});
