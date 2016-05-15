import Vapor

let app = Application()

app.get("/") { request in
	return try app.view("home.html")
}

app.get(Link.self, handler: LinkController(application: app).redirect)

// app.resource("links", controller: LinkController.self)
app.get("links", handler: LinkController(application: app).index)
app.post("links", handler: LinkController(application: app).store)

app.middleware.append(SampleMiddleware())

app.start(port: 8080)
