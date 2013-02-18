#!/bin/sh
jekyll --no-auto
rsync -av  _site/ webmaster@chroma.andrewvc.com:/var/www/blog.andrewvc.com/_site
