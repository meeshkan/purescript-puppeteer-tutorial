/*const chromium = require("chrome-aws-lambda");
const fs = require("fs");
exports.handler = async (event, context, callback) => {
  let result = null;
  let browser = null;

  try {
    browser = await chromium.puppeteer.launch({
      args: chromium.args,
      defaultViewport: chromium.defaultViewport,
      executablePath: await chromium.executablePath,
      headless: chromium.headless,
      ignoreHTTPSErrors: true,
    });

    let page = await browser.newPage();

    await page.goto(event.url || "https://example.com");
    await page.screenshot({ path: "/tmp/example.png" });
    const contents = fs.readFileSync("/tmp/example.png", {
      encoding: "base64",
    });

    result = contents;
  } catch (error) {
    return callback(error);
  } finally {
    if (browser !== null) {
      await browser.close();
    }
  }

  return callback(null, result);
};
*/
var main = require("./output/Main");
exports.handler = function(event, context, callback) {
  main.handler(event)(context)(callback)();
};
