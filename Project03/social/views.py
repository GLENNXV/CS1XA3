from django.http import HttpResponse,HttpResponseNotFound
from django.shortcuts import render,redirect,get_object_or_404
from django.contrib.auth.forms import AuthenticationForm, UserCreationForm, PasswordChangeForm
from django.contrib.auth import authenticate, login, logout, update_session_auth_hash
from django.contrib import messages

from . import forms
from . import models

def messages_view(request):
    """Private Page Only an Authorized User Can View, renders messages page
       Displays all posts and friends, also allows user to make new posts and like posts
    Parameters
    ---------
      request: (HttpRequest) - should contain an authorized user
    Returns
    --------
      out: (HttpResponse) - if user is authenticated, will render private.djhtml
    """
    if request.user.is_authenticated:
        user_info = models.UserInfo.objects.get(user=request.user)


        # TODO Objective 9: query for posts (HINT only return posts needed to be displayed)
        posts = []
        poLimit=request.session.get("poLimit", default=3)
        poSize=0
        for i in models.Post.objects.order_by("-timestamp"):
            if poSize==poLimit:
                break
            posts.append(i)
            poSize+=1
        request.session["poLimit"]=poLimit

        # TODO Objective 10: check if user has like post, attach as a new attribute to each post
        liked=user_info not in i.likes.all()

        context = { 'user_info' : user_info,
                    'posts' : posts, 
                    'liked':liked }
        return render(request,'messages.djhtml',context)

    request.session['failed'] = True
    return redirect('login:login_view')

def account_view(request):
    """Private Page Only an Authorized User Can View, allows user to update
       their account information (i.e UserInfo fields), including changing
       their password
    Parameters
    ---------
      request: (HttpRequest) should be either a GET or POST
    Returns
    --------
      out: (HttpResponse)
                 GET - if user is authenticated, will render account.djhtml
                 POST - handle form submissions for changing password, or User Info
                        (if handled in this view)
    """
    if request.user.is_authenticated:
        form2=forms.InfoForm(request.POST)

        # TODO Objective 3: Create Forms and Handle POST to Update UserInfo / Password
        
        user_info = models.UserInfo.objects.get(user=request.user)
        if request.POST:
            form=PasswordChangeForm(request.user,request.POST)
            if form.is_valid():
                user=form.save()
                update_session_auth_hash(request,user)
                messages.success(request, 'Your password was successfully updated!')
                return redirect('social:account_view')
            else:
                messages.error(request, 'Please correct the error below.')
            if form2.is_valid():
                if request.POST.get('employment')!='' and request.POST.get('employment') is not None:
                    user_info.employment=request.POST.get('employment')
                    user_info.save()
                if request.POST.get('location')!='' and request.POST.get('location') is not None:
                    user_info.location=request.POST.get('location')
                    user_info.save()
                if request.POST.get('birthday')!='' and request.POST.get('birthday') is not None:
                    user_info.birthday=request.POST.get('birthday')
                    user_info.save()
                if request.POST.get('interests')!='' and request.POST.get('interests') is not None:
                    interests=[]
                    for i in user_info.interests.all():
                        interests.append(i.label)
                    if request.POST.get('interests') not in interests:
                        newInterest=models.Interest(label=request.POST.get('interests'))
                        newInterest.save()
                        user_info.interests.add(newInterest)
                        user_info.save()

        else:
            form=PasswordChangeForm(request.user)
        context = { 'user_info' : user_info,
                    'form' : form ,
                    'form2' : form2}
        return render(request,'account.djhtml',context)

    request.session['failed'] = True
    return redirect('login:login_view')

def people_view(request):
    """Private Page Only an Authorized User Can View, renders people page
       Displays all users who are not friends of the current user and friend requests
    Parameters
    ---------
      request: (HttpRequest) - should contain an authorized user
    Returns
    --------
      out: (HttpResponse) - if user is authenticated, will render people.djhtml
    """
    if request.user.is_authenticated:
        user_info = models.UserInfo.objects.get(user=request.user)
        # TODO Objective 4: create a list of all users who aren't friends to the current user (and limit size)
        pLimit=request.session.get("pLimit", default=2)
        all_people = []
        pSize=0
        for i in models.UserInfo.objects.all():
            if i not in user_info.friends.all() and i.user!=request.user:
                if pSize==pLimit:
                    break
                all_people.append(i)
                pSize+=1
        request.session["pLimit"]=pLimit

        # TODO Objective 5: create a list of all friend requests to current user
        friend_requests = []
        alreadySent=[]
        for i in models.FriendRequest.objects.all():
            if user_info==i.to_user:
                friend_requests.append(i)
            if user_info==i.from_user:
                alreadySent.append(i)

        
        context = { 'user_info' : user_info,
                    'all_people' : all_people,
                    'friend_requests' : friend_requests,
                    'alreadySent' : alreadySent, }

        return render(request,'people.djhtml',context)

    request.session['failed'] = True
    return redirect('login:login_view')

def like_view(request):
    '''Handles POST Request recieved from clicking Like button in messages.djhtml,
       sent by messages.js, by updating the corrresponding entry in the Post Model
       by adding user to its likes field
    Parameters
	----------
	  request : (HttpRequest) - should contain json data with attribute postID,
                                a string of format post-n where n is an id in the
                                Post model

	Returns
	-------
   	  out : (HttpResponse) - queries the Post model for the corresponding postID, and
                             adds the current user to the likes attribute, then returns
                             an empty HttpResponse, 404 if any error occurs
    '''
    postIDReq = request.POST.get('postID')
    if postIDReq is not None:
        # remove 'post-' from postID and convert to int
        # TODO Objective 10: parse post id from postIDReq
        postID = int(postIDReq[5:])

        if request.user.is_authenticated:
            # TODO Objective 10: update Post model entry to add user to likes field
            user_info=models.UserInfo.objects.get(user=request.user)
            likePost=models.Post.objects.get(id=postID)
            if user_info not in likePost.likes.all():
                likePost.likes.add(user_info)
                likePost.save()
            # return status='success'
            return HttpResponse()
        else:
            return redirect('login:login_view')

    return HttpResponseNotFound('like_view called without postID in POST')

def post_submit_view(request):
    '''Handles POST Request recieved from submitting a post in messages.djhtml by adding an entry
       to the Post Model
    Parameters
	----------
	  request : (HttpRequest) - should contain json data with attribute postContent, a string of content

	Returns
	-------
   	  out : (HttpResponse) - after adding a new entry to the POST model, returns an empty HttpResponse,
                             or 404 if any error occurs
    '''
    postContent = request.POST.get('newContent')
    if postContent is not None:
        if request.user.is_authenticated:

            # TODO Objective 8: Add a new entry to the Post model
            user_info=models.UserInfo.objects.get(user=request.user)
            newPost=models.Post(owner=user_info,content=postContent)
            newPost.save()
            # return status='success'
            return HttpResponse()
        else:
            return redirect('login:login_view')

    return HttpResponseNotFound('post_submit_view called without postContent in POST')

def more_post_view(request):
    '''Handles POST Request requesting to increase the amount of Post's displayed in messages.djhtml
    Parameters
	----------
	  request : (HttpRequest) - should be an empty POST

	Returns
	-------
   	  out : (HttpResponse) - should return an empty HttpResponse after updating hte num_posts sessions variable
    '''
    if request.user.is_authenticated:
        # update the # of posts dispalyed

        # TODO Objective 9: update how many posts are displayed/returned by messages_view

        # return status='success'
        poLimit=request.session.get("poLimit", default=2)
        request.session["poLimit"]=poLimit+2
        return HttpResponse("More Posts Coming up...")

    return redirect('login:login_view')

def more_ppl_view(request):
    '''Handles POST Request requesting to increase the amount of People displayed in people.djhtml
    Parameters
	----------
	  request : (HttpRequest) - should be an empty POST

	Returns
	-------
   	  out : (HttpResponse) - should return an empty HttpResponse after updating the num ppl sessions variable
    '''
    if request.user.is_authenticated:
        # update the # of people dispalyed

        # TODO Objective 4: increment session variable for keeping track of num ppl displayed

        # return status='success'
        pLimit=request.session.get("pLimit", default=2)
        request.session["pLimit"]=pLimit+2
        return HttpResponse("More People Coming up...")

    return redirect('login:login_view')

def friend_request_view(request):
    '''Handles POST Request recieved from clicking Friend Request button in people.djhtml,
       sent by people.js, by adding an entry to the FriendRequest Model
    Parameters
	----------
	  request : (HttpRequest) - should contain json data with attribute frID,
                                a string of format fr-name where name is a valid username

	Returns
	-------
   	  out : (HttpResponse) - adds an etnry to the FriendRequest Model, then returns
                             an empty HttpResponse, 404 if POST data doesn't contain frID
    '''
    frID = request.POST.get('frID')
    if frID is not None:
        # remove 'fr-' from frID
        username = frID[3:]

        if request.user.is_authenticated:
            # TODO Objective 5: add new entry to FriendRequest

            # return status='success'
            to_user_name=models.User.objects.get(username=username)
            to_user=models.UserInfo.objects.get(user=to_user_name)
            from_user=models.UserInfo.objects.get(user=request.user)
            newRequest=models.FriendRequest(to_user=to_user,from_user=from_user)
            newRequest.save()
            return HttpResponse("Request Sent")
        else:
            return redirect('login:login_view')

    return HttpResponseNotFound('friend_request_view called without frID in POST')

def accept_decline_view(request):
    '''Handles POST Request recieved from accepting or declining a friend request in people.djhtml,
       sent by people.js, deletes corresponding FriendRequest entry and adds to users friends relation
       if accepted
    Parameters
	----------
	  request : (HttpRequest) - should contain json data with attribute decision,
                                a string of format A-name or D-name where name is
                                a valid username (the user who sent the request)

	Returns
	-------
   	  out : (HttpResponse) - deletes entry to FriendRequest table, appends friends in UserInfo Models,
                             then returns an empty HttpResponse, 404 if POST data doesn't contain decision
    '''
    data = request.POST.get('decision')
    if data is not None:
        # TODO Objective 6: parse decision from data
        if data[0]=="A":
            decision=True
        elif data[0]=="D":
            decision=False
        to_user = models.UserInfo.objects.get(user=request.user)
        from_user_name=models.User.objects.get(username=data[2:])
        from_user=models.UserInfo.objects.get(user=from_user_name)
        theRequest=models.FriendRequest.objects.get(to_user=to_user,from_user=from_user)

        if request.user.is_authenticated:

            # TODO Objective 6: delete FriendRequest entry and update friends in both Users

            # return status='success'
            if decision:
                from_user.friends.add(to_user)
                to_user.friends.add(from_user)
                from_user.save()
                to_user.save()
            theRequest.delete()
            return HttpResponse("success")
        else:
            return redirect('login:login_view')

    return HttpResponseNotFound('accept-decline-view called without decision in POST')
