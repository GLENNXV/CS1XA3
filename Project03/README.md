# CS 1XA3 Project03 - <xus83@mcmaster.ca>
## Usage
run pre-installed conda enivornment with
```
conda activate djangoenv
```

Run locally with
```
python manage.py runserver localhost:8000
```
Run on mac1xa3.ca with
```
python manage.py runserver localhost:10112
```

and visit [mac1xa3.ca/e/xus83](https://mac1xa3.ca/e/xus83) in modern browers 

## Log in with
**TestUser**, asdfghjkl1234\
**asdf**, asdfghjkl1234\
**Morty**, asdfghjkl1234\
**Barney_Stinson**, asdfghjkl1234\
**Ted_Mosby**, asdfghjkl1234\
**omgimsobad**, asdfghjkl1234\
**ThisShit**, asdfghjkl1234\
**Jon_Snow**, asdfghjkl1234\
**67tghbyu67iogb**, asdfghjkl1234

## Objective 1: Complete Login and SignUp Pages (5 points)

Description:
- this feature is displayed in `signup.djhtml` which is rendered by `signup_view`
- it makes a POST Request to from something.js to `/e/xus83/signup` which is handled by `signup_view`

Exceptions:
- If the user is not authenticated, redirect to `login.djhtml`

## Objective 2: Adding User Profile and Interests (5 points)
Description:
- this feature is displayed in `social_base.djhtml` which is rendered by `messages_view`, `people_view` and `account_view`

Exceptions:
- If the user is not authenticated, redirect to `login.djhtml`

## Objective 3: Account Settings Page (10 points)
Description:
- this feature is displayed in `account.djhtml` which is rendered by `account_view`
- it handles a POST Request from `account.js` to `/e/xus83/social/account` which is handled by `account_view`
- the POST request contains a django built-in form `PasswordChangeForm` and a custom form `InfoForm` defined in `forms.py`

Exceptions:
- If the user is not authenticated, redirect to `login.djhtml`

##  Objective 4: Displaying People List (10 points)
Description:
- this feature is displayed in `people.djhtml` which is rendered by `people_view`
- the more button is already linked to send an `AJAX POST` from `people.js`, which is handled by `more_ppl_view`
- a session variable `pLimit` is used to keep track of how many people to display

Exceptions:
- If the user is not authenticated, redirect to `login.djhtml`

##  Objective 5: Sending Friend Requests (10 points)
Description:
- this feature is displayed in `people.djhtml` which is rendered by `friend_request_view` and `people_view`
- it handles a POST Request from `people.js` to `/e/xus83/social/people` which is handled by `friend_request_view`
- `people_view` is used to display other users

Exceptions:
- If the user is not authenticated, redirect to `login.djhtml`

## Objective 6: Accepting / Declining Friend Requests (10 points)
Description:
- this feature is displayed in `people.djhtml` which is rendered by `accept_decline_view`
- it handles a POST Request from `people.js` to `/e/xus83/social/people` which is handled by `accept_decline_view`

Exceptions:
- If the user is not authenticated, redirect to `login.djhtml`

## Objective 7: Displaying Friends (5 points)
Description:
- this feature is displayed in `message.djhtml` which is rendered by `messages_view`

Exceptions:
- If the user is not authenticated, redirect to `login.djhtml`

## Objective 8: Submitting Posts (10 points)
Description:
- this feature is displayed in `message.djhtml` which is rendered by `messages_view`
- the more button is already linked to send an `AJAX POST` from `message.js`, which is handled by `post_submit_view`
- Reload the page upon a success response

Exceptions:
- If the user is not authenticated, redirect to `login.djhtml`

## Objective 9: Displaying Post List (10 points)
Description:
- this feature is displayed in `message.djhtml` which is rendered by `messages_view` and `more_post_view`
- the more button is already linked to send an `AJAX POST` from `message.js`, which is handled by `post_submit_view`
- Reload the page upon a success response
- Reset how many posts are displayed when the User logs out

Exceptions:
- If the user is not authenticated, redirect to `login.djhtml`

##  Objective 10: Liking Posts (and Displaying Like Count) (10 points)
Description:
- this feature is displayed in `message.djhtml` which is rendered by `messages_view` and `like_view`
- the more button is already linked to send an `AJAX POST` from `message.js`, which is handled by `like_view`
- Reload the page upon a success response

Exceptions:
- If the user is not authenticated, redirect to `login.djhtml`

## Objective 11: Create a Test Database (5 points)
Description:
- Created a variety of test users, created many posts and likes and different friend requests to showcase all the functionality that have been implemented

-  Add and commited the sqlite3.db file and migrations folders so that the TA’s marking the assignment have access to the database that have been populated

## References
[Django Documentation](https://docs.djangoproject.com/en/3.0/)\
[StackOverflow](https://stackoverflow.com/questions/7837033/valueerror-cannot-add-instance-is-on-database-default-value-is-on-databas/7999014)\
[W3School](https://www.w3schools.com/js/js_ajax_intro.asp)