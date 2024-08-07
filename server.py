#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug  7 08:50:52 2024

@author: buddha
"""

import flask
import csv
from os import path
app = flask.Flask("Mfinder Server")
persons = {}

def pathfind(name):
    return path.join(path.split(__file__)[0], name)

@app.route("/mfinder_html/<path>")
def get_mfinder_utility(path):
    return flask.send_from_directory(pathfind("mfinder_html"), path)

@app.route("/<name>")
def find_name(name):
    if name == "__version__":
        return "1"
    try:
        return persons[name.replace("_", " ").lower()]
    except:
        flask.abort(400)

@app.route("/")
def mfinder():
    return flask.redirect("/mfinder_html/mfinder.html")

with open(pathfind("data.txt")) as file:
    reader = csv.reader(file)
    for row in reader:
        persons[row[0].lower()] = ",".join(row)
print(persons)
app.run()
