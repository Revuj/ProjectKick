@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'project'])

@section('title', 'Project_name | Issues List')

@section('style')
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="{{asset('css/issuelist.css')}}" />
    <link rel="stylesheet" href="{{asset('css/navbar.css')}}" />
@endsection

@section('script')
    <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
    <script
      src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
      integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
      integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
      integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
      crossorigin="anonymous"
    ></script>
    <script src="{{asset('js/issueslist.js')}}" defer></script>
    <script src="{{asset('js/navbar.js')}}" defer></script>
    <script src="{{asset('js/index.js')}}" defer></script>
@endsection


@section('content')
<div class="main-content-container px-4">
          <nav>
            <ol class="breadcrumb custom-separator">
              <li><a href="#0" id="project-name" data-project={{ $project->id }}>{{ $project->name }}</a></li>
              <li><a href="#0">Issues</a></li>
              <li class="current">List</li>
            </ol>
          </nav>
          <div id="issue-list-container" class="pt-1 mb-0">
            <ul class="d-flex border-bottom nav-links pb-2">
              <li id="open-issues" class="active">
              Open <span class="type-counter">{{ $openIssues }}</span>
              </li>
              <li id="closed-issues">
                Closed <span class="type-counter">{{ $closedIssues }}</span>
              </li>
              <li id="all-issues">
                All <span class="type-counter">{{ $openIssues + $closedIssues}}</span>
              </li>
              <button
                type="button"
                data-toggle="modal"
                data-target="#addTaskModal"
                class="btn btn-success ml-auto "
              >
                <i class="fa fa-plus-circle fa-lg"></i> <span>Add Task</span>
              </button>
            </ul>

            <div id="filter-issues" class="border-bottom py-3 my-0">
              <form class="d-md-flex justify-content-between">
                <div class="form-group mb-0 flex-grow-1">
                  <input
                    type="text"
                    class="form-control"
                    name="issues-filter"
                    id="issues-filter"
                    placeholder="Search or filter results..."
                  />
                </div>
                <div id="filter-buttons" class="dropdown ml-1">
                  <button
                    data-toggle="dropdown"
                    aria-haspopup="true"
                    aria-expanded="false"
                    id="dropdownFiltersButton"
                    type="button"
                    type="submit"
                    class="custom-button primary-button dropdown-toggle"
                  >
                    Sort by<i class="fas fa-chevron-down ml-3"></i>
                  </button>
                  <div
                    class="dropdown-menu"
                    aria-labelledby="dropdownFiltersButton"
                  >
                    <a class="dropdown-item" href="#">Due Date</a>
                    <a class="dropdown-item" href="#">Opening Date</a>
                    <a class="dropdown-item" href="#">Assignees</a>
                  </div>
                  <button id = "asc-button" class="custom-button primary-button">
                    <i class="fas fa-arrow-up"></i>
                  </button>
                </div>
              </form>
            </div>
          </div>

          <ul id="issue-list" class="mx-2">
            @foreach ($issueLists as $list)
              @foreach ($list->issues()->get() as $issue)
              @if ($issue->is_completed)
                <li id={{ $issue->id }} class="issue closed d-none px-2 border-bottom">
              @else
                <li id={{ $issue->id }} class="issue open px-2 border-bottom">
              @endif
                <span class="issue-description d-none">{{ $issue->description }}</span>
                <span class="issue-due-date d-none">
                  @if ($issue->due_date == null)
                    none
                  @else
                    {{ \Carbon\Carbon::parse($issue->due_date)->format('M d Y') }}
                  @endif
                </span>
                  <div class="issue-header d-flex align-items-center">
                    <a href="issue.html" class="task-title nostyle">{{ $issue->name }}</a>
                      <ul class="d-flex justify-content-center mx-2">
                      @foreach (\App\Tag::join('issue_tag', 'tag.id', '=', 'issue_tag.tag_id')->where('issue_tag.issue_id', '=', $issue->id )->get() as $issueTag)                        
                          <li class="mr-2">
                            <h6 class="mb-0 px-1 list-item-label bg-info">{{ $issueTag->name }}</h6>
                            {{-- <h6  style="background-color:#{{ $issueTag->color->rgb_code }}" class="mb-0 px-1 list-item-label">{{ $issueTag->name }}</h6> --}}
                          </li>              
                      @endforeach
                      </ul>
                      @if ($issue->due_date != null)
                        <div class="due-date-container text-right">
                          <i class="fas fa-calendar-alt mr-2"></i>{{ \Carbon\Carbon::parse($issue->due_date)->format('M d Y') }}
                        </div>
                      @endif
                    <a href="issue.html" class="nostyle comments-number-container ml-auto">
                      <i class="fas fa-comments mr-2"></i>{{ count($issue->comments) }}
                    </a>
                  </div>
                  <div class="d-flex issue-status align-items-end">
                    <p>
                      #{{ $issue->id }}<span class="issue-status-description">
                        Opened by <span class="author-reference">{{ \App\User::find($issue->author_id)->username }}</span>
                         {{ \Carbon\Carbon::parse($issue->creation_date)->format('M d Y') }}
                        </span>
                    </p>
            
                    <div class="assignees-container mt-2 ml-auto text-center">
                      <ul class="assignees d-flex ">
                        @foreach (\App\User::join('assigned_user', 'user.id', '=', 'assigned_user.user_id')->where('assigned_user.issue_id', '=', $issue->id )->get() as $assignee)
                          <li class="mr-2 assignee">
                            <img
                              src="{{asset('assets/avatars/' . "profile". '.png')}}"
                              alt="{{ $assignee->username }}"
                              draggable="false"
                            />
                          </li>
                        @endforeach
                      </ul>
                    </div>
                  </div>
                </li>
              @endforeach
            @endforeach
          </ul>
        </div>
      </div>
      <!--end of main-container can possible be a section in the future-->

     <!-- Sidebar Issue -->
     <div id="side-issue-container">
      <div id="side-issue" class="d-flex flex-column h-100 mx-3 py-3">
        <div id="side-issue-header" class="border-bottom mb-3">
          <div class="d-flex align-items-start">
            <h4 class="task-title mr-auto">HELLO</h4>
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
            <button type="button" class="btn close-side-issue">
              <i class="fas fa-times"></i>
            </button>
          </div>
          <p class="w-100">
            #1 Opened by <span id="issue-author" class="author-reference"></span>
          </p>
        </div>
        <div id="issue-description">
        </div>
        <div class="assignees-container mt-3">
          <h6 class="block py-2 font-weight-bold">Assignees</h6>
          <ul class="assignees d-flex align-items-center">
          </ul>
        </div>
        <div class="labels-container mt-3">
          <h6 class="block py-2 font-weight-bold">Labels</h6>
          <ul class="labels d-flex align-items-center">
            <li>
              <button
                type="button"
                class="custom-button add-button add-label"
              >
                <i class="fas fa-plus"></i>
              </button>
            </li>
          </ul>
        </div>
        <div class="due-date-container mt-3">
          <h6 class="block py-2 font-weight-bold">Due Date</h6>

          <button type="button" class="custom-button due-date-button">
            <i class="far fa-clock mr-2"></i><span id="due-date"></span>
          </button>
        </div>
        <button
          id="delete-issue-button"
          type="button"
          class="custom-button close-button delete-issue mt-auto"
        >
          Delete
        </button>
      </div>
    </div>


      <div
        class="modal"
        id="addTaskModal"
%
        aria-labelledby="addTaskModalLabel"
        aria-hidden="true"
      >
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="addTaskModalLabel">Add Task</h5>
              <button
                type="button"
                class="close"
                data-dismiss="modal"
                aria-label="Close"
              >
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <form>
                <div class="form-row">
                  <div class="col">
                    <label for="board-name" class="col-form-label"
                      >Select Board</label
                    >
                    <input type="text" class="form-control" id="board-name" />
                  </div>
                </div>
                <div class="form-group mt-4">
                  <input
                    type="text"
                    class="form-control"
                    id="task-name"
                    placeholder="What needs to be done?"
                  />
                </div>
                <div class="form-row">
                  <div class="col">
                    <label for="task-assignment" class="col-form-label"
                      >Who should do this?</label
                    >
                    <input
                      type="text"
                      class="form-control"
                      id="task-assignment"
                    />
                  </div>
                  <div class="col">
                    <label for="task-due-date" class="col-form-label"
                      >Due Date</label
                    >
                    <input
                      type="date"
                      class="form-control"
                      id="task-due-date"
                    />
                  </div>
                </div>
              </form>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn " data-dismiss="modal">
                Close
              </button>
              <button type="button" class="btn btn-success">Add Task</button>
            </div>
          </div>
        </div>
      </div>
@endsection
