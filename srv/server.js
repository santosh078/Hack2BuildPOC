const express = require("express");
const cds = require("@sap/cds");
var cors = require('cors');
const proxy = require("@sap/cds-odata-v2-adapter-proxy");
var bodyParser = require('body-parser');
const host = "0.0.0.0";
const port = process.env.PORT || 4004;

(async () => {
  const app = express();
  app.use(cors());
  app.use(express.json());
  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded({ extended: true })); 


  // OData V2
  app.use(proxy());

  // OData V4
  //   await cds.connect("db").serve("all").in(app);

  const server = app.listen(port, host, () => console.info(`app is listing at ${host}:${port}`));
  server.on("error", error => console.error(error.stack));
})();