@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'project'])

@section('title', 'Project | Issue')

@section('style')
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="{{asset('css/issue.css')}}" />
    <link rel="stylesheet" href="{{asset('css/navbar.css')}}" />
@endsection

@section('script')
    <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
    <script src="{{asset('js/navbar.js')}}" defer></script>
    <script src="{{asset('js/index.js')}}" defer></script>
    <script src="{{asset('js/issue.js')}}" defer></script>

@endsection


@section('content')
<div class="main-content-container px-4">
  <nav>
    <ol class="breadcrumb custom-separator">
      <li><a href="/projects/{{$issue->issueList->project_id}}">Project</a></li>
      <li><a href="/projects/{{$issue->issueList->project_id}}/issuelist">Issues</a></li>
      <li class="current">#{{$issue->id}}</li>
    </ol>
  </nav>
  <div id="issue-container">
    <div id="issue" class="d-flex flex-column h-100 text-left">
      <div id="issue-header" class="mb-0 d-flex flex-column">
        <div class="d-flex align-items-center pt-2">
          <p class="mr-auto i smaller-text mb-0">
          @if($issue['is_completed'] === false)
          <span class="bg-success text-light issue-status">Open</span>
          @else
          <span class="bg-danger text-light issue-status">Closed</span>
          @endif


            <span class="issue-status-description">
           
            Created {{ date_format(date_create($issue['creation_date']), '\o\n l jS F Y')}} by 
            <a class = "nostyle" href="/users/{{$author->id}}"> <span class="author-reference">{{$author->name}}</span></a>
             
              
              </span>
          </p>
          <button class="custom-button close-button">
            <i class="fas fa-check-circle"></i>
          </button>
          <form class="edit-issue-title-form form-group d-none mr-auto">
            <div class="form-group text-left">
              <input
                type="text"
                class="form-control"
                class="item-title"
                placeholder=""
              />
            </div>
            <div class="d-flex justify-content-between">
              <button
                type="submit"
                class="btn btn-primary edit-item-title btn"
              >
                Submit
              </button>
              <button
                type="reset"
                class="btn btn-primary edit-item-title-cancel"
              >
                Cancel
              </button>
            </div>
          </form>
          <button type="button" class="btn d-none edit-task mr-1">
            <i class="fas fa-pencil-alt float-right"></i>
          </button>
        </div>
        <div class="d-flex align-items-center my-2">
          <h4 class="title task-title mr-auto mt-2" id="issue-title">
            {{$issue['name']}}
          </h4>
          <input
            type="text"
            class="form-control d-none"
            id="edit-task-label"
          />
          <button
            type="button"
            class="custom-button edit-button edit-task d-none ml-auto"
            id="save-issue"
            data-issue-id="{{ $issue['id'] }}"
          >
            <i class="far fa-save"></i>
          </button>
          <button
            type="button"
            class="custom-button edit-button edit-task"
            id="edit-issue"
          >
            <i class="fas fa-pencil-alt"></i>
          </button>
        </div>
        <ul class="labels smaller-text d-flex align-items-center">
        @foreach($tags as $tag)
        <li class="mr-2">
            <h6 class="label mb-0 px-1 list-item-label bg-info p-1 text-white" style="background-color:{{$tag->rgb_code}};" >
              {{$tag->name}}
            </h6>
        </li>
        @endforeach
          <li>
            <button
              type="button"
              class="d-none custom-button add-button"
            >
              <i class="fas fa-plus"></i>
            </button>
          </li>
        </ul>
      </div>
      <div class="row border-bottom my-2">
        <div class="col-md-9 description text-left">
          <p id="issue-description">
          {{$issue['description']}}
          </p>
          <input
          type="text"
          class="form-control d-none"
          id="edit-task-description"
        />
        </div>
        <div
          class="col-md-3 members-and-duedate pb-3 d-flex flex-column justify-content-end ml-auto"
        >
          <div class="assignees-container ml-auto">
            <ul
              class="assignees d-flex align-items-center justify-content-center pb-3"
            >

            @foreach($users as $user)
            <li class="mr-2">
            <a href="/users/{{$user['id']}}">
              <img src="{{ asset('assets/avatars/'.  $user['photo_path'] .'.png') }}" alt="{{ $user['username']}} profile picture" />
            </a>
            </li>
            @endforeach
            </ul>
          </div>
          <div class="due-date-container ml-auto">
            <button type="button" class="custom-button due-date-button">
              <i class="far fa-clock mr-2"></i>
              @if(!$issue['due_date'] === NULL)
                Not defined
              @else
                {{ date_format(date_create($issue['due_date']), 'jS F Y')}}
              @endif
            </button>
          </div>
        </div>
      </div>
      <div class="add-comment-container">
      
      <div class = "position-relative w-100 py-3 mb-5">
        <div class = "mt-0 p-2 rounded position-absolute w-100 d-none" id = "dialog">
          <div class="error-content ml-3">
            <i class="fas fa-exclamation-triangle"></i>
              <span class = "ml-2 content"> Something went wrong</span>
          </div>
        </div>
      </div>

        <form class="d-flex">
          <img class = "comment-author" src="{{ asset('assets/avatars/'.  Auth::User()['photo_path'] .'.png') }}" alt="{{ Auth::User()['username']}} profile picture" />
          <input
            class="w-100 mx-2 px-2"
            type="text"
            name="comment"
            id="new-comment"
            placeholder=" Write a comment..."
            data-user = "{{Auth::Id()}}"
            data-issue = "{{$issue->id}}"
          />
        </form>
      </div>
      <div class="comments-container">

      @foreach ($comments as $comment)
      
      <div class="comment d-flex border-bottom mt-4 pb-1">
        <img class = "comment-author" src="{{ asset('assets/avatars/'.  $comment['photo_path'] .'.png') }}" alt="{{ $comment['username']}} profile picture" />

          <div class="comment-detail ml-3">
            <h6>
              <a href="/users/{{$comment['user_id']}}"><span class="author-reference">{{ $comment['username']}}</span></a>
              <span class="comment-timestamp ml-1"> {{ date_format(date_create($comment['creation_date']),'h:i a \o\n l jS F Y')}}</span>
            </h6>
            <p>
              {{$comment['content']}}
            </p>
          </div>
          <div data-target = "{{$comment['id']}}" class="karma ml-auto mr-3 d-flex flex-column">
            

            @php
              $vote = $comment->votes->where('user_id', Auth::Id());
              $upvote = $vote->first()['upvote'];
            @endphp

            @if ($vote->count() > 0)
              @if($upvote === 1)
                <i class="fas fa-chevron-up upvote voted"></i>
                <p class="mb-0 text-center">{{$comment['total']}}</p>
                <i class="fas fa-chevron-down downvote"></i>
              @else
                <i class="fas fa-chevron-up upvote"></i>
                <p class="mb-0 text-center">{{$comment['total']}}</p>
                <i class="fas fa-chevron-down downvote voted"></i>
              @endif
            @else
              <i class="fas fa-chevron-up upvote"></i>
              <p class="mb-0 text-center">{{$comment['total']}}</p>
              <i class="fas fa-chevron-down downvote"></i>
            @endif

          </div>
        </div>

      @endforeach

      </div>
    </div>
  </div>
</div>
@endsection
