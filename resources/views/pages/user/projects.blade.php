@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'user', 'user' => $user_id])

@section('title', 'Kick | My Projects')

@section('script')
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
    integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous">
</script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
    integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous">
</script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
    integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous">
</script>
<script src="https://kit.fontawesome.com/23412c6a8d.js"></script>

<script src="{{asset('js/index.js')}}" defer></script>
<script src="{{asset('js/my_projects.js')}}" defer></script>

@endsection

@section('style')
<!-- Styles -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
<link rel="stylesheet" href="{{ asset('css/my_projects.css') }}" />
<link rel="stylesheet" href="{{ asset('css/navbar.css') }}" />
@endsection

@section('content')
<div class="main-content-container px-4">
    <nav>
        <ol class="breadcrumb custom-separator">
            <li class="current">Dashboard</li>
        </ol>
    </nav>

    <div class="w-100 pb-2 my-1">
        <div class="mt-0 p-2 rounded  w-100 d-none" id="dialog">
            <div class="error-content ml-3">
                <span class="content">

                </span>
            </div>
        </div>
    </div>

    <div class="w-100 pb-2 my-1">
        <div class="mt-0 p-2 rounded  w-100 d-none" id="dialog">
            <div class="error-content ml-3">
                <span class="content">

                </span>
            </div>
        </div>
    </div>
    <div id="tables-types" class="d-flex border-bottom nav-links pb-2">
        <li class="active">
            Active <span class="tables-type-counter">{{ $projects->where('finish_date', null)->count() }} </span>
        </li>
        <li>Finished <span class="tables-type-counter">{{ $projects->where('finish_date', '!=', null)->count() }}</span>
        </li>
        <button type="button" data-toggle="modal" data-target="#addProjectModal" class="btn btn-success ml-auto ">
            <i class="fa fa-plus-circle fa-lg"></i>
            <span>Add Project</span>
        </button>
    </div>
    <div id="filter-issues" class="border-bottom py-3 my-0">
        <form class="d-md-flex justify-content-between">
            @csrf
            <div class="form-group mb-0 flex-grow-1">

                <!-- [FILTER]-->


                <div id="searchbar" type="text">
                    <input name="project-filter" class="form control" id="project-filter" type="text"
                        placeholder="Search or query for a project ..." />

                    <button id="searchbarbutton">
                        <svg focusable="false" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                            <path
                                d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z">
                            </path>
                        </svg>
                    </button>
                </div>

            </div>

            <div id="filter-buttons" class="dropdown ml-1">
                <!--
                <button
                  data-toggle="dropdown"
                  aria-haspopup="true"
                  aria-expanded="false"
                  id="dropdownFiltersButton"
                  type="button"
                  type="submit"
                  class="custom-button primary-button"
                > 
                  Sort by<i class="fas fa-chevron-down ml-3"></i>
                </button>-->
                <!--
                <div
                  class="dropdown-menu"
                  aria-labelledby="dropdownFiltersButton"
                >
                  <a class="dropdown-item" href="#">Due Date</a>
                  <a class="dropdown-item" href="#">Opening Date</a>
                  <a class="dropdown-item" href="#">Assignees</a>
                </div> -->

                <select class="custom-button primary-button h-100 mx-1" name="filter-select" id="filter-select">
                    <option class="primary-button custom-button" value="due-date">Due Date</option>
                    <option class="primary-button custom-button" value="opening-date">Opening Date</option>
                    <option class="primary-button custom-button" value="name">Name</option>
                </select>

                <button type="button" id="orderType" class="custom-button primary-button">
                    <i class="fas fa-arrow-up"></i>
                </button>
            </div>
        </form>


    </div>
    <div class="p-2 card-columns row" id="active-projects">
        @foreach ($projects as $project)
        @php
        $total_issues = count($project->project->issues()->get());
        $closed_issues = count($project->project->issues()->where('is_completed', '=', 'true')->get());
        $open_issues = count($project->project->issues()->where('is_completed', '=', 'false')->get());
        @endphp
        @if ($project->finish_date == null)
        <div class="card-container col-lg-4 col-md-6 col-sm-12 p-1">
            <div class="card project" id="{{ $project->id }}">
                <div class="card-header d-flex align-items-center">
                    <a class="text-decoration-none title" href="/projects/{{ $project->id }}">{{ $project->name }}
                    </a>
                    <button type="button" class="btn delete-project-button ml-auto" data-toggle="modal"
                        data-target="#delete-project-modal" data-project="{{ $project->id }}">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                    <br />
                </div>
                <div class="card-body">
                    <span id="description">
                        <span>
                            {{ $project->description }}
                        </span>
                    </span>
                    <div>
                        <div class="my-2 progress" style="height: 5px;">
                            <div class="progress-bar" role="progressbar" aria-valuenow="80" aria-valuemin="0"
                                aria-valuemax="100" @if ($total_issues> 0)
                                style="width: {{$closed_issues / $total_issues * 100}}%;"
                                @else
                                style="width: 0%;"
                                @endif
                                ></div>
                        </div>
                        <div>
                            Tasks Completed:<span class="text-inverse"> {{ $closed_issues }}/{{ $total_issues }}</span>
                        </div>
                    </div>
                    <div class="mt-3 project-members">
                        @foreach (\App\MemberStatus::where('project_id', '=', $project->id)->join('user', 'user.id',
                        '=', 'member_status.user_id')->get() as $member)
                        <div class="avatar-image avatar-image--loaded mr-2">
                            <div class="avatar avatar--md avatar-image__image">
                                <div class="avatar__content">
                                    <img src="{{asset('assets/avatars/' . $member->photo_path . '.png')}}" alt="" />
                                </div>
                            </div>
                        </div>
                        @endforeach
                    </div>
                </div>
                <div class="d-flex justify-content-left card-footer">
                    <span class="font-weight-lighter">Created at
                        {{ \Carbon\Carbon::parse($project->creation_date)->format('M d Y') }}</span>
                </div>
            </div>
        </div>
        @endif
        @endforeach
    </div>
    {{$projects->links()}}
    <div class="p-2 card-columns d-none">
        @foreach ($projects as $project)
        @if ($project->finish_date != null)
        <div class="card project" id="{{ $project->id }}">
            <div class="card-header d-flex align-items-center">
                <a class="text-decoration-none title" href="project_overview.html">{{ $project->name }}
                </a>
                @can('delete', $project)
                <button type="button" class="btn delete-project-button ml-auto" data-toggle="modal"
                    data-target="#delete-project-modal" data-project="{{ $project->id }}">
                    <i class="fas fa-trash-alt"></i>
                </button>
                @endcan
                <br />
            </div>
            <div class="card-body">
                <span id="description">
                    <span>
                        {{ $project->description }}
                    </span>
                </span>
                <div>
                    <div class="my-2 progress" style="height: 5px;">
                        <div class="progress-bar" role="progressbar" aria-valuenow="80" aria-valuemin="0"
                            aria-valuemax="100" style="width: 80%;"></div>
                    </div>
                    <div>
                        Tasks Completed:<span class="text-inverse">36/94</span>
                    </div>
                </div>
                <div class="mt-3 project-members">
                    @foreach (\App\MemberStatus::where('project_id', '=', $project->id)->join('user', 'user.id', '=',
                    'member_status.user_id')->get() as $member)
                    <div class="avatar-image avatar-image--loaded mr-2">
                        <div class="avatar avatar--md avatar-image__image">
                            <div class="avatar__content">
                                <img src="{{asset('assets/avatars/' . $member->photo_path . '.png')}}" alt="" />
                            </div>
                        </div>
                    </div>
                    @endforeach
                </div>
            </div>

            <div class="d-flex justify-content-left card-footer">
                <span class="font-weight-lighter">Created at
                    {{ \Carbon\Carbon::parse($project->creation_date)->format('M d Y') }}</span>
            </div>
        </div>
        @endif
        @endforeach
    </div>
    <div class="d-flex p-2">
        {{-- <nav class="" aria-label="Page navigation example">
              <ul class="pagination">
                <li class="page-item">
                  <a href="#" class="page-link" aria-label="Previous"
                    ><span aria-hidden="true"
                      ><i class="fa fa-fw fa-angle-left"></i></span
                    ><span class="sr-only">Previous</span></a
                  >
                </li>
                <li class="page-item active">
                  <a href="#" class="page-link">1</a>
                </li>
                <li class="page-item"><a href="#" class="page-link">2</a></li>
                <li class="page-item"><a href="#" class="page-link">3</a></li>
                <li class="page-item">
                  <a href="#" class="page-link" aria-label="Next"
                    ><span aria-hidden="true"
                      ><i class="fa fa-fw fa-angle-right"></i></span
                    ><span class="sr-only">Next</span></a
                  >
                </li>
              </ul>
            </nav> --}}
    </div>
</div>

{{-- Delete Project Modal --}}
<!-- Delete list modal -->
<div class="modal fade" id="delete-project-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Delete</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body text-left">
                <p>
                    Are you sure you want to delete this project?
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    Close
                </button>
                <button id="delete-project-button" type="button" data-dismiss="modal"
                    class="btn btn-primary btn-danger">
                    Delete
                </button>
            </div>
        </div>
    </div>
</div>
</div>

{{-- Create Project Modal --}}
<div class="modal" id="addProjectModal" tabindex="-1" role="dialog" aria-labelledby="addProjectModalLabel"
    aria-hidden="true" data-photo="{{ $user_photo_path }}">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addProjectModalLabel">
                    Create Project
                </h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="new-project-form">
                    <div class="form-group">
                        <label for="project-name" class="col-form-label">Name</label>
                        <input type="text" class="form-control" id="project-name" />
                    </div>
                    <div class="form-group">
                        <label for="project_description" class="col-form-label">Description</label>
                        <textarea class="form-control" id="project_description"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="project_tags" class="col-form-label">Tags</label>
                        <br />
                        <div class="d-flex">
                            <ul class="labels d-flex mx-2">
                                <li class="mr-2">
                                    <h6 class="mb-0 px-1 list-item-label bg-success">
                                        a3
                                    </h6>
                                </li>
                            </ul>
                            <button class="btn p-0">
                                <i class="fa fa-tag mr--small"></i>
                            </button>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn " data-dismiss="modal">
                            Close
                        </button>
                        <button id="create-project" type="button" class="btn btn-success" data-user="{{ $user_id }}">
                            Create
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

@endsection