# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  index_1 = page.body.index(e1)
  index_2 = page.body.index(e2)
  assert index_1 <= index_2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(', ')
  if uncheck
    ratings.each do |rating|
      step "I uncheck \"ratings_#{rating}\""
    end
  else
    ratings.each do |rating|
      step "I check \"ratings_#{rating}\""
    end   
  end
end

Then /^ratings should show "(.*)"/ do |rating|
  assert page.has_xpath?("//td[text()='#{rating}']")
end

Then /^ratings should not show "(.*)"/ do |rating|
  assert page.has_no_xpath?("//td[text()='#{rating}']")
end

Then /^I should see all of the movies$/ do
  all_movies_count = Movie.all.count
  rows = page.all(:css, 'table tbody tr')
  assert rows.count == all_movies_count
end
