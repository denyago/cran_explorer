# A try and very simple CRAN client/cache

[![Build Status](https://travis-ci.org/denyago/cran_explorer.svg?branch=master)](https://travis-ci.org/denyago/cran_explorer)
[![Code Climate](https://codeclimate.com/github/denyago/cran_explorer/badges/gpa.svg)](https://codeclimate.com/github/denyago/cran_explorer)

Import data (from first to 11th): `rails r 'Importer.new(0, 10, Logger.new(STDOUT)).import!'`

Run a UI `rails s`, open http://localhost:3000/packages
