@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'project', 'project' => $project->id])

@section('title', 'Kick | Team members')

@section('script')
    <script
      src="https://code.jquery.com/jquery-3.3.1.js"
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
    <script type="text/javascript" src="https://cdn.rawgit.com/prashantchaudhary/ddslick/master/jquery.ddslick.min.js" ></script>
    <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
    <script src="{{asset('js/index.js')}}" defer></script>
    <script src="{{asset('js/project_team.js')}}" defer></script>

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
    <link rel="stylesheet" href="{{ asset('css/project_team.css') }}" />
    <link rel="stylesheet" href="{{ asset('css/navbar.css') }}"/>
@endsection

@section('content')
<div class="main-content-container px-4">
          <nav>
            <ol class="breadcrumb custom-separator">
              <li><a href="#0" id="project-name">{{ $project->name }}</a></li>
              <li><a href="#0">Project Overview</a></li>
              <li class="current">Project Members</li>
            </ol>
          </nav>
          <div id="tables-types" class="d-flex border-bottom nav-links pb-2">
            <li class="active">
              Developer <span id="developers-counter" class="tables-type-counter">{{ count(\App\MemberStatus::where('project_id', '=', $project->id)->where('role', '=', 'developer')->join('user', 'user.id', '=', 'member_status.user_id')->get()) }}</span>
            </li>
            <li>Coordinator <span id="coordinators-counter" class="tables-type-counter">{{ count(\App\MemberStatus::where('project_id', '=', $project->id)->where('role', '=', 'coordinator')->join('user', 'user.id', '=', 'member_status.user_id')->get()) }}</span></li>
            <li>All <span id="total-counter" class="tables-type-counter">{{ count(\App\MemberStatus::where('project_id', '=', $project->id)->join('user', 'user.id', '=', 'member_status.user_id')->get()) }}</span></li>
            <div class="ml-auto">
              @can('leave', $project)
              <button
                type="button"
                data-toggle="modal"
                data-target="#leave-modal"
                class="btn btn-close mr-1"
              >
                <i class="fas fa-sign-out-alt"></i>
                <span>Leave</span>
              </button>
              @endcan
              <button
                type="button"
                data-toggle="modal"
                data-target="#addMemberModal"
                class="btn btn-success"
              >
                <i class="fa fa-plus-circle fa-lg"></i>
                <span>Add Member</span>
              </button>
            </div>
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
                <div class="table-responsive" id="developers">
                  <table class="table user-list">
                    <thead>
                      <tr>
                        <th class="font-weight-bold" style="width: 30%">
                          User
                        </th>
                        <th class="font-weight-bold" style="width: 20%">
                          Joined
                        </th>
                        <th class="font-weight-bold" style="width: 20%">
                          Email
                        </th>
                        @can('coordinator', $project)
                          <th class="font-weight-bold" style="width: 30%">
                            &nbsp;
                          </th>
                        @endcan
                      </tr>
                    </thead>
                    <tbody>
                      @foreach (\App\MemberStatus::where('project_id', '=', $project->id)->where('role', '=', 'developer')->join('user', 'user.id', '=', 'member_status.user_id')->get() as $member)
                        <tr class="user_{{$member->user_id}}">
                          <td data-label="User">
                            <img src="{{asset('assets/avatars/' . $member->photo_path . '.png')}}" alt="" />
                            <a href="#" class="user-link">{{ $member->username }}</a>
                            <span class="user-subhead">{{ $member->role }}</span>
                          </td>
                          <td data-label="Joined">
                            {{ \Carbon\Carbon::parse($member->entrance_date)->format('M d Y') }}
                          </td>
                          <td data-label="Email">
                            <a href="#">{{ $member->email }}</a>
                          </td>
                          @can('coordinator', $project)
                          <td align="center">
                            <a href="#" class="table-link">
                              <button class="custom-button close-button" data-toggle="modal" data-target="#remove-member-modal" data-user="{{ $member->user_id }}" data-username="{{ $member->username }}">
                                <i class="fa fa-trash fa"></i>
                                Remove
                              </button>
                            </a>
                            <a href="#" class="table-link">
                              <button class="custom-button open-button" data-toggle="modal" data-target="#promote-member-modal" data-user="{{ $member->user_id }}" data-username="{{ $member->username }}">
                                <i class="fa fa-arrow-alt-circle-up"></i>
                                Promote
                              </button>
                            </a>
                          </td>
                          @endcan
                        </tr>
                      @endforeach
                    </tbody>
                  </table>
                </div>
                <div class="table-responsive d-none" id="coordinators">
                  <table class="table user-list">
                    <thead>
                      <tr>
                        <th class="font-weight-bold" style="width: 30%">
                          User
                        </th>
                        <th class="font-weight-bold" style="width: 20%">
                          Joined
                        </th>
                        <th class="font-weight-bold" style="width: 20%">
                          Email
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      @foreach (\App\MemberStatus::where('project_id', '=', $project->id)->where('role', '=', 'coordinator')->join('user', 'user.id', '=', 'member_status.user_id')->get() as $member)
                        <tr class="user_{{$member->user_id}}">
                          <td data-label="User">
                            <img src="{{asset('assets/avatars/' . $member->photo_path . '.png')}}" alt="" />
                            <a href="#" class="user-link">{{ $member->username }}</a>
                            <span class="user-subhead">{{ $member->role }}</span>
                          </td>
                          <td data-label="Joined">
                            {{ \Carbon\Carbon::parse($member->entrance_date)->format('M d Y') }}
                          </td>
                          <td data-label="Email">
                            <a href="#">{{ $member->email }}</a>
                          </td>
                        </tr>
                      @endforeach
                    </tbody>
                  </table>
                </div>
                <div class="table-responsive d-none" id="all">
                  <table class="table user-list">
                    <thead>
                      <tr>
                        <th class="font-weight-bold" style="width: 30%">
                          User
                        </th>
                        <th class="font-weight-bold" style="width: 20%">
                          Joined
                        </th>
                        <th class="font-weight-bold" style="width: 20%">
                          Email
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      @foreach (\App\MemberStatus::where('project_id', '=', $project->id)->join('user', 'user.id', '=', 'member_status.user_id')->get() as $member)
                        <tr class="user_{{$member->user_id}}">
                          <td data-label="User">
                            <img src="{{asset('assets/avatars/' . $member->photo_path . '.png')}}" alt="" />
                            <a href="#" class="user-link">{{ $member->username }}</a>
                            <span class="user-subhead">{{ $member->role }}</span>
                          </td>
                          <td data-label="Joined">
                            {{ \Carbon\Carbon::parse($member->entrance_date)->format('M d Y') }}
                          </td>
                          <td data-label="Email">
                            <a href="#">{{ $member->email }}</a>
                          </td>
                        </tr>
                      @endforeach
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div
          class="modal"
          id="addMemberModal"
          tabindex="-1"
          role="dialog"
          aria-labelledby="addMemberModalLabel"
          aria-hidden="true"
        >
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="addMemberModalLabel">
                  Add Member
                </h5>
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
                <form onsubmit="return false">
                  <div class="form-group">
                    <label for="username" class="col-form-label">Username</label>
                    <input type="text" class="form-control" id="username" />
                  </div>
                  <div id="users_dropdown"></div>
                  <div id="error" class="mt-2"></div>
                </form>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn" data-dismiss="modal">
                  Close
                </button>
                <button type="button" class="btn btn-success" id="add-member" data-project="{{ $project->id }}">
                  Add Member
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Leave modal -->
        <div
          class="modal fade"
          id="leave-modal"
          tabindex="-1"
          role="dialog"
          aria-labelledby="exampleModalLabel"
          aria-hidden="true"
        >
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Leave project?</h5>
                <button
                  type="button"
                  class="close"
                  data-dismiss="modal"
                  aria-label="Close"
                >
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body text-left">
                <p>
                  This action will remove you from the project. Are you sure you want to continue?
                </p>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn" data-dismiss="modal">
                  Close
                </button>
                <button
                  id="leave-button"
                  type="button"
                  data-dismiss="modal"
                  class="btn btn-close"
                >
                  Leave
                </button>
              </div>
            </div>
          </div>
        </div>
        

        <!-- Remove Member modal -->
        <div
          class="modal fade"
          id="remove-member-modal"
          tabindex="-1"
          role="dialog"
          aria-labelledby="exampleModalLabel"
          aria-hidden="true"
        >
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Remove <span id="user-to-remove"> from the project?</span></h5>
                <button
                  type="button"
                  class="close"
                  data-dismiss="modal"
                  aria-label="Close"
                >
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body text-left">
                <p>
                  This action will remove the member you select from the project. Are you sure you want to continue?
                </p>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn" data-dismiss="modal">
                  Close
                </button>
                <button
                  id="remove-member"
                  type="button"
                  data-dismiss="modal"
                  class="btn btn-close"
                >
                  Remove
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Promote Member modal -->
        <div
          class="modal fade"
          id="promote-member-modal"
          tabindex="-1"
          role="dialog"
          aria-labelledby="exampleModalLabel"
          aria-hidden="true"
        >
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Promote <span id="user-to-promote"> from the project?</span></h5>
                <button
                  type="button"
                  class="close"
                  data-dismiss="modal"
                  aria-label="Close"
                >
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body text-left">
                <p>
                  This action will promote the member you select from the project. Are you sure you want to continue?
                </p>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn" data-dismiss="modal">
                  Close
                </button>
                <button
                  id="promote-member"
                  type="button"
                  data-dismiss="modal"
                  class="btn btn-success"
                >
                  Promote
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

@endsection