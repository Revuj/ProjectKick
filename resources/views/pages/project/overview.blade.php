@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'project'])

@section('title', 'Kick | Project Overview')

@section('script')
<script
      src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
      integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
      integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
      integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
      crossorigin="anonymous"
    ></script>
    <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>

    <script src="{{asset('js/index.js')}}" defer></script>
    
@endsection

@section('style')
    <!-- Styles -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
      integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw="
      crossorigin="anonymous"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
      integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw="
      crossorigin="anonymous"
    />
    <link
      rel="stylesheet"
      href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
      integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
      crossorigin="anonymous"
    />
    <link rel="stylesheet" href="{{ asset('css/project_overview.css') }}" />
    <link rel="stylesheet" href="{{ asset('css/navbar.css') }}"/>
@endsection

@section('content')
<div class="main-content-container px-4">
          <nav>
            <ol class="breadcrumb custom-separator">
              <li><a href="#0">lbaw</a></li>
              <li class="current">Project Overview</li>
            </ol>
          </nav>
          <div id="project-container">
            <div id="project" class="d-flex flex-column h-100 py-3 text-left">
              <div
                id="project-header"
                class="border-bottom mb-3 d-flex flex-row align-items-center"
              >
                <h3 class="title project-title mr-auto mb-2">Project Kick</h3>
                <div class="d-flex align-items-start">
                  <p class="mr-auto">
                    <span class="project-creator">
                      Project created by
                      <span class="author-reference text-primary"
                        >Revuj</span
                      ></span
                    >
                  </p>
                </div>
              </div>
              <div class="row">
                <div class="col-md-7">
                  <div class="project-section general-info">
                    <div class="d-flex mb-2">
                      <h4 class="flex-grow-1 description">Description</h4>
                      <button
                        type="button"
                        class="custom-button edit-button edit-task mr-1"
                      >
                        <i
                          class="ml-auto fas fa-pencil-alt float-right"
                          aria-hidden="true"
                        ></i>
                      </button>
                    </div>
                    <p class="mb-4">
                      The purpose of this project is to develop a system for
                      project management, allowing the clients to create their
                      own workflows as well as customize them, enabling to plan
                      ahead, monitoring the work progress and communicate with
                      the team in a flexible and organized way. In a world where
                      the majority of the development comes from maintaining and
                      building projects, having a tool where everything can be
                      managed is now one of the key elements in projects,
                      playing an important role in its organization and success.
                      Through this application, users, within teams, can create
                      customizable lists for their tasks and issues with items
                      that can be moved through different lists and have an
                      overview of the lists through a representation in the form
                      of a table or a Kanban board.
                    </p>

                    <div class="row">
                      <div class="col">
                        <label>Created</label>
                        <p class="font-weight-bold mb-4">2017/11/02</p>
                        <label>Duration</label>
                        <p class="font-weight-bold mb-4">
                          90 days
                          <span class="text-muted"
                            ><small>(50 days remaining)</small></span
                          >
                        </p>
                        <label>Status</label> <br />
                        <span class="badge badge-success">Active</span>
                      </div>
                      <div class="col">
                        <label>Progress</label>
                        <div class="mb-2 progress" style="height: 5px;">
                          <div
                            class="progress-bar"
                            role="progressbar"
                            aria-valuenow="80"
                            aria-valuemin="0"
                            aria-valuemax="100"
                            style="width: 80%;"
                          ></div>
                        </div>
                        <p class="mb-4">
                          Tasks Completed:<span class="text-inverse"
                            >36/94</span
                          >
                        </p>
                        <label>Project Members</label>
                        <ul class="assignees d-flex align-items-center">
                          <li class="mr-2">
                            <img
                              src="https://avatars3.githubusercontent.com/u/41621540?s=40&v=4"
                              alt="@vitorb19"
                              draggable="false"
                            />
                          </li>
                          <li class="mr-2">
                            <img
                              src="https://avatars2.githubusercontent.com/u/44231794?s=40&v=4"
                              alt="@vitorb19"
                              draggable="false"
                            />
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-md-5">
                  <div class="card mb-3">
                    <div class="card-header">
                      <i class="fa fa-tasks"></i> <span>Recent Issues</span>
                    </div>
                    <div class="card-body">
                      <ul class="list-unstyled simple-todo-list">
                        <li>
                          <a href="issue.html" class="task-title nostyle"
                            >make pages responsive</a
                          >
                          <p class="smaller-text">
                            #10<span class="open-description"></span>
                            Opened by
                            <span class="author-reference">Abelha</span> 4 days
                            ago
                          </p>
                        </li>
                        <li>
                          <a href="issue.html" class="task-title nostyle"
                            >normalize database</a
                          >
                          <p class="smaller-text">
                            #15
                            <span class="open-description"
                              >Opened by
                              <span class="author-reference">Vator</span> 2 days
                              ago</span
                            >
                          </p>
                        </li>
                      </ul>
                    </div>
                  </div>
                  <div class="card mb-3">
                    <div class="card-header">
                      <i class="fa fa-comment-alt"></i> <span>Channels</span>
                    </div>
                    <div class="card-body">
                      <div class="chat_list active_chat">
                        <a class="chat_ib">
                          <p># developers-team</p>
                        </a>
                      </div>
                      <div class="chat_list">
                        <a class="chat_ib">
                          <p>
                            # annoucements-hq <span class="unread_msgs">3</span>
                          </p>
                        </a>
                      </div>
                      <div class="chat_list">
                        <a class="chat_ib">
                          <p>
                            # relaxing-room <span class="unread_msgs">1</span>
                          </p>
                        </a>
                      </div>
                    </div>
                  </div>
                  <!-- END RECENT FILES -->
                </div>
              </div>
            </div>
          </div>
        </div>
@endsection

