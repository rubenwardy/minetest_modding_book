#!/usr/bin/node

var wordCount = require('html-word-count');
var fs = require("fs");
var jsdom = require("jsdom");

var text = fs.readFileSync("_site/cat.html");

const { JSDOM } = jsdom;
const { window } = new JSDOM(text);
const { document } = (window).window;
global.document = document;
var $ = require('jquery')(window);

$("pre").remove();

console.log(wordCount(document.documentElement.innerHTML)); // 2
