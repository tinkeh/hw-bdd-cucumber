# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  Movie.create(:title => movie["title"], :rating => movie["rating"], :release_date => movie["release_date"])
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  if page.body.index(e1) > page.body.index(e2)
    fail
  end
end

# Allows the ability to check multiple ratings boxes at once

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /^I (un)?check the following ratings: (.*)$/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  r_list = rating_list.split(", ")
  for r in r_list.each
    r = /[PGR]+(-13)?/.match(r).string
    if r[0] == "\""
      r = r[1..(r.length - 1)]
    elsif r[r.length - 1] == "\""
      r = r[0..(r.length - 2)]
    end
    r = "ratings_" + r
    if uncheck
      uncheck(r)
    else
      check(r)
    end
  end
end

Then /^I should see all the movies$/ do
  # Make sure that all the movies in the app are visible in the table
  page.should have_css("table#movies tr", :count=>Movie.count + 1)
end
