---
---
"use strict";

const puppeteer = require("puppeteer")
const fs = require("fs")
const os = require("os")

var links = {{ site.data.links_en | jsonify }};

(async() => {
	const browser = await puppeteer.launch()
	const page = await browser.newPage()

	var root = "file:///" + __dirname + "/../en/"
	console.log("Root is: " + root)

	for (var i = 0; i < links.length; i++) {
		var link = links[i]
		if (link.link) {
			console.log("Rendering " + link.title)
			await page.goto(root + link.link, {waitUntil: "networkidle"})

			// page.pdf() is currently supported only in headless mode.
			// @see https://bugs.chromium.org/p/chromium/issues/detail?id=753118
			const margin = "0.2in"
			await page.pdf({
				path: "tmp/page_" + (link.num || ("0_" + link.title.replace(".", "_"))) + ".pdf",
				format: "A5",
				margin: {
					top: margin,
					right: margin,
					bottom: margin,
					left: margin,
				}
			})
		}
	}
	browser.close()

})()
