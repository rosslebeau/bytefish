import Vapor
import Mustache

let app = Application()

app.providers.append(MustacheProvider(withIncludes: [
    "head": "Includes/head.mustache"
]))

app.get("/") { request in
	return try app.view("home.mustache")
}

app.get(Link.self, handler: LinkController(application: app).redirect)

// app.resource("links", controller: LinkController.self)
app.get("links", handler: LinkController(application: app).index)
app.post("links", handler: LinkController(application: app).store)
app.get("links", Link.self, handler: LinkController(application: app).show)

app.middleware.append(SampleMiddleware())

app.start(port: 8080)
