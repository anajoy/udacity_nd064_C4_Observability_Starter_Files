from flask import Flask, render_template, request, jsonify

import pymongo
from flask_pymongo import PyMongo

import logging
from jaeger_client import Config
from opentracing.ext import tags
from opentracing.propagation import Format
from flask_opentracing import FlaskTracer
import requests
import json

app = Flask(__name__)

app.config["MONGO_DBNAME"] = "example-mongodb"
app.config[
    "MONGO_URI"
] = "mongodb://example-mongodb-svc.default.svc.cluster.local:27017/example-mongodb"

mongo = PyMongo(app)

@app.route("/")
def homepage():
    with tracer.start_span("get-home-page", child_of=parent_span) as span:
        response = {"message": "Hello World"}

        span.set_tag("message", response)
    return jsonify(response)


@app.route("/api")
def my_api():
    with tracer.start_span("get-api", child_of=parent_span) as span:
        answer = {"message": "API called"}
        span.set_tag("message", answer)
    return jsonify(repsonse=answer)

@app.route("/star", methods=["POST"])
def add_star():
    with tracer.start_span("post-star", child_of=parent_span) as span:
        try:
            star = mongo.db.stars
            name = request.json["name"]
            distance = request.json["distance"]
            star_id = star.insert({"name": name, "distance": distance})
            new_star = star.find_one({"_id": star_id})
            output = {"name": new_star["name"], "distance": new_star["distance"]}
            response = jsonify({"result": output})
            span.set_tag("message", json.dumps(response))
            span.set_tag("http.status_code", response.status_code)
            return response
        except:
            span.set_tag("response", "No response retrieved from Mongo DB")
            span.set_tag("http.status_code", response.status_code)

def init_tracer(service):
    logging.getLogger('').handlers = []
    logging.basicConfig(format='%(message)s', level=logging.DEBUG)
    config = Config(
        config={
            'sampler': {
                'type': 'const',
                'param': 1,
            },
            'logging': True,
        },
        service_name=service,
    )
    # this call also sets opentracing.tracer
    return config.initialize_tracer()

tracer = init_tracer('backend')
flask_tracer = FlaskTracer(tracer, True, app)
parent_span = flask_tracer.get_span()

if __name__ == "__main__":
    app.run()
