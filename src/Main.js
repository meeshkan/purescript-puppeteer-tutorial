var chromium = require("chrome-aws-lambda");

exports.executablePath_ = function() {
  return chromium.executablePath;
};

exports.launchBrowser_ = function(executablePath) {
  return function() {
    return chromium.puppeteer.launch({
      args: chromium.args,
      defaultViewport: chromium.defaultViewport,
      executablePath: executablePath,
      headless: chromium.headless,
      ignoreHTTPSErrors: true,
    });
  };
};
exports.newPage_ = function(browser) {
  return function() {
    return browser.newPage();
  };
};

exports.goto_ = function(page) {
  return function(url) {
    return function() {
      return page.goto(url);
    };
  };
};

exports.screenshot_ = function(page) {
  return function(path) {
    return function() {
      return page.screenshot({ path: path });
    };
  };
};

exports.close_ = function(browser) {
  return function() {
    return browser.close();
  };
};

exports.title_ = function(page) {
  return function() {
    return page.title();
  };
};

exports.resolveCallback = function(cb) {
  return function(res) {
    return function() {
      cb(null, res);
    };
  };
};
