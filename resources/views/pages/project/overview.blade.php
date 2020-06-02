@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'project', 'project' =>
$project->id] )

@section('title', 'Kick | Project Overview')

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
<script src="{{asset('js/project.js')}}" defer></script>


@endsection

@section('style')
<!-- Styles -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
<link rel="stylesheet" href="{{ asset('css/project_overview.css') }}" />
<link rel="stylesheet" href="{{ asset('css/navbar.css') }}" />
@endsection

@section('content')
<div class="main-content-container px-4">
    <nav>
        <ol class="breadcrumb custom-separator">
            <li><a href="#">{{ $project->name }}</a></li>
            <li class="current"><i class="fas fa-project-diagram"></i> Project Overview</li>
        </ol>
    </nav>
    <div id="project-container">
        <div id="project" class="d-flex flex-column h-100 py-3 text-left">
            <div id="project-header" class="border-bottom mb-3 d-flex flex-row align-items-center">
                <h3 id="project-title" class="title project-title mr-auto mb-2 pr-2">{{ $project->name }}</h3>
                <div class="d-flex align-items-start">
                    <p class="mr-auto">
                        <span class="project-creator">
                            Project created by
                            <span class="author-reference">
                                <a class="nostyle" href="/users/{{$project->author_id}}">
                                    {{ $author->username }}
                                </a>
                            </span></span>
                    </p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-7">
                    <div class="project-section general-info">
                        <div class="d-flex mb-2">
                            <h4 class="flex-grow-1 description">Description</h4>
                            <button id="edit-project" type="button" class="custom-button edit-button mr-1">
                                <i class="ml-auto fas fa-pencil-alt float-right" aria-hidden="true"></i>
                            </button>
                            <button id="save-project" type="button" class="custom-button edit-button mr-1"
                                data-project="{{ $project->id }}">
                                <i class="ml-auto far fa-save float-right"></i>
                            </button>
                        </div>
                        <p class="mb-4" id="project-description">
                            {{ $project->description }}
                        </p>

                        <div class="row">
                            <div class="col">
                                <label>Created</label>
                                <p class="font-weight-bold mb-4">
                                    {{ date_format(date_create($project->creation_date), 'jS F Y')}}
                                </p>
                                <label>Duration</label>
                                <p class="font-weight-bold mb-4">
                                    @if ($remaing !== NULL)
                                    {{$duration}} start
                                    @else
                                    Not yet defined
                                    @endif
                                    <span class="text-muted p-0 m-0">
                                        <small>
                                            @if ($remaing !== NULL)
                                            @if ($remaing === 0)
                                            (No days remaining)
                                            @else
                                            ({{$remaing}} today)
                                            @endif
                                            @endif
                                        </small>
                                    </span>
                                </p>
                                <label>Status</label> <br />
                                @if ($active === true)
                                <span class="badge badge-success">Active</span>
                                @else
                                <span class="badge badge-danger">Inactive</span>
                                @endif
                            </div>
                            <div class="col">
                                <label>Progress</label>
                                <div class="mb-2 progress" style="height: 5px;">
                                    <div class="progress-bar" role="progressbar" aria-valuenow="80" aria-valuemin="0"
                                        aria-valuemax="100" @if (count($project->issues()->get()) > 0)
                                        style="width:
                                        {{count($project->issues()->where('is_completed', '=', 'true')->get()) / count($project->issues()->get()) * 100}}%;"
                                        @else
                                        style="width: 0%;"
                                        @endif
                                        ></div>
                                </div>
                                <p class="mb-4">
                                    Tasks Completed:<span class="text-inverse">
                                        {{ count($project->issues()->where('is_completed', '=', 'true')->get()) }}/{{ count($project->issues()->get()) }}</span>
                                </p>
                                <label>Project Members</label>
                                <ul class="assignees d-flex align-items-center">
                                    @foreach (\App\MemberStatus::where('project_id', '=', $project->id)->join('user',
                                    'user.id', '=', 'member_status.user_id')->get() as $member)
                                    <li class="mr-2">
                                        <img src="{{asset('assets/avatars/' . $member->photo_path . '.png')}}" alt="" />
                                    </li>
                                    @endforeach
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-5">
                    <div class="card mb-3">
                        <div class="card-header">
                            <i class="fa fa-tasks mx-1"></i> <span>Recent Issues</span>
                        </div>
                        <div class="card-body">
                            <ul class="list-unstyled simple-todo-list">

                                @foreach ($issues as $issue)
                                <li class="mb-2 border-bottom w-100 author">
                                    <a href="/issues/{{$issue->issue_id}}" class="task-title nostyle">{{$issue->name}}
                                    </a>
                                    <p class="smaller-text">
                                        <span class="open-description"></span>
                                        Opened by
                                        <span class="author-reference">
                                            <a class="nostyle" href="/users/{{$issue->user_id}}">
                                                {{$issue->username}}
                                            </a>
                                        </span>
                                        {{$issue->diff_date}}
                                    </p>
                                </li>
                                @endforeach
                            </ul>
                        </div>
                    </div>
                    <div class="card mb-3">
                        <div class="card-header">
                            <i class="fa fa-comment-alt mx-1"></i> <span>Channels</span>
                        </div>
                        <div class="card-body">

                            @foreach($channels as $channel)

                            <div class="chat_list border-bottom mb-2">
                                <a class="chat_ib">
                                    <p class="m-0 p-0 author-reference">
                                        <a class="nostyle" href="{{$project->id}}/chats/{{$channel->id}}">
                                            # {{$channel->name}}
                                        </a>
                                    </p>
                                    <p class=" m-0 p-0">
                                        <small>
                                            Created {{$channel->diff_date}}
                                        </small>
                                    </p>
                                </a>
                            </div>
                            @endforeach

                        </div>
                    </div>
                    <!-- END RECENT FILES -->
                </div>
            </div>
        </div>
    </div>
</div>
@endsection