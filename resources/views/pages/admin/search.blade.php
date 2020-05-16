@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'admin'])

@section('title', 'Administrator | Search')

@section('style')
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="{{asset('css/admin_users_projects.css')}}" />
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
    <script src="{{asset('js/admin_user_projects.js')}}" defer></script>
    <script src="{{asset('js/index.js')}}" defer></script>
@endsection

@php
  $today = getdate();
  echo $projects;
@endphp

@section('content')
<div class="main-content-container px-4">
          <nav>
            <ol class="breadcrumb custom-separator">
              <li class="current">Users and Projects</li>
            </ol>
          </nav>
          <div id="tables-types" class="d-flex border-bottom p-2">
            <li class="active">
              Users <span class="tables-type-counter">{{count($users)}}</span>
            </li>
            <li>Projects <span class="tables-type-counter">{{count($projects)}}</span></li>
          </div>
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
                <button type="submit" class="custom-button primary-button">
                  <i class="fas fa-arrow-up"></i>
                </button>
              </div>
            </form>
          </div>
          <div class="row m-2">
            <div class="mx-auto">
              <div class="main-box clearfix">
                <div class="table-responsive" id="users">
                  <table class="table user-list">
                    <thead>
                      <tr>
                        <th class = "text-center" style="width: 25%">User</th>
                        <th class = "text-center" style="width: 20%">Created</th>
                        <th class="text-center" style="width: 15%">Status</th>
                        <th class = "text-center" style="width: 25%">Email</th>
                        <th class = "text-center" style="width: 15%">&nbsp;</th>
                      </tr>
                    </thead>
                    <tbody>

                    @foreach($users as $user)
                      @include('partials.Admin.userTr', $user)
                    @endforeach
                    </tbody>
                  </table>
                </div>

                <div class="table-responsive d-none" id="projects">
                  <table class="table project-list">
                    <thead>
                      <tr>
                        <th style="width: 30%">Projects</th>
                        <th style="width: 15%">Created</th>
                        <th class="text-center" style="width: 15%">Status</th>
                        <th style="width: 25%">Progress</th>
                        <th style="width: 15%">&nbsp;</th>
                      </tr>
                    </thead>
                    <tbody>

                    @foreach($projects as $project)
                      @include('partials.Admin.projectTr', $project)
                    @endforeach
                     
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <div
            class="modal"
            id="addTaskModal"
            tabindex="-1"
            role="dialog"
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
                        <label for="project-name" class="col-form-label"
                          >Select Project</label
                        >
                        <input
                          type="text"
                          class="form-control"
                          id="project-name"
                        />
                      </div>
                      <div class="col d-none">
                        <label for="task-list" class="col-form-label"
                          >Task List</label
                        >
                        <input
                          type="text"
                          class="form-control"
                          id="task-list"
                        />
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
                  <button type="button" class="btn btn-success">Add</button>
                </div>
              </div>
            </div>
          </div>
        </div>
@endsection
