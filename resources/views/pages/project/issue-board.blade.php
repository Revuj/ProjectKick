@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'project', 'project' =>
$project->id])

@section('title', 'Project_name | Issues Board')

@section('style')
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
<link rel="stylesheet" href="{{asset('css/board.css')}}" />
<link rel="stylesheet" href="{{asset('css/navbar.css')}}" />
@endsection

@section('script')
<script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
    integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous">
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
    integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous">
</script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
    integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous">
</script>
<script src="{{asset('js/board.js')}}" defer></script>
<script src="{{asset('js/index.js')}}" defer></script>
@endsection


@section('content')
<nav>
    <ol class="breadcrumb custom-separator">
        <li><a href="#0" id="project-name" data-project={{ $project->id }}>{{ $project->name }}</a></li>
        <li><a href="#0">Issues</a></li>
        <li class="current">Boards</li>
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

<section class="board-options d-flex flex-row bd-highlight align-items-center">
    <!-- create a new task-->
    <div class=" bd-highlight">
        <form id="add-list-form" class="input-group inputArea">
            <input type="text" class="form-control listCreated" placeholder="Add list" />
            <div class="input-group-append">
                <button class="btn btn-success add-list mr-1" type="button">
                    <i class="fa fa-plus"></i>
                </button>
            </div>
        </form>
    </div>
</section>

<section class="kanban-container mt-2">
    <div class="kanban-table d-flex flex-row bd-highlight align-items-begin">
        @foreach ($issueLists as $list)
        <div class="bd-highlight task" id="task-list-{{ $list->id }}">
            <div class="task-list-title d-flex align-items-center py-0">
                <h6 class="mr-auto my-0 text-left p-3">
                    <i class="fa fa-fw fa-caret-right"></i>{{ $list->name }}
                </h6>
                <button class="btn mx-4 p-0 order-3" data-toggle="collapse" data-target="#add-item-{{ $list->id }}"
                    aria-expanded="false" aria-controls="add-item">
                    <i class="fas fa-plus"></i>
                </button>
                @can('coordinator', $project)
                <button type="button" class="btn" data-toggle="modal" data-target="#delete-list-modal"
                    data-list-id="task-list-{{ $list->id }}" data-list-name="task-list-{{ $list->name }}">
                    <i class="fas fa-trash-alt"></i>
                </button>
                @endcan
            </div>
            <ul class="task-items">
                @foreach ($list->issues()->get() as $issue)
                <li id={{ $issue->id }} class="task-item text-left" draggable="true">
                    <div class="d-flex flex-row align-items-center ml-2 row-1">
                        <a class="nostyle" href="/issues/{{ $issue->id }}">
                            <h6 class="mb-0 py-2 task-title title">{{ $issue->name }}</h6>
                        </a>
                        @can('update', $issue)
                        <button type="button" class="btn ml-auto d-none edit-task">
                            <i class="fas fa-pencil-alt float-right"></i>
                        </button>
                        @endcan
                    </div>
                    <span class="issue-description d-none">{{ $issue->description }}</span>
                    <span class="issue-due-date d-none">
                        @if ($issue->due_date == null)
                        none
                        @else
                        {{ \Carbon\Carbon::parse($issue->due_date)->format('M d Y') }}
                        @endif
                    </span>
                    <span class="d-flex flex-row align-items-center mx-2 row-2">
                        <p class="w-100 mb-2">
                            <span class="list-item-counter">#{{ $issue->id }}</span>
                            <span>opened by <span
                                    class="author-reference">{{ \App\User::find($issue->author_id)->username }}</span>
                        </p>
                    </span>
                    <span class="d-flex justify-content-between ml-2">
                        <span class="d-flex flex-row labels-selected flex-wrap">
                            @foreach (\App\Tag::join('issue_tag', 'tag.id', '=',
                            'issue_tag.tag_id')->where('issue_tag.issue_id', '=', $issue->id )->get() as $issueTag)
                            {{-- <h6 style="background-color:#{{ $issueTag->color->rgb_code }}" class="mb-0 p-1
                            list-item-label mr-1">
                            {{ $issueTag->name }}
                            </h6> --}}
                            <h6 class="mb-1 p-1 list-item-label mr-1 bg-info" data-label-id={{ $issueTag->id }}>
                                {{ $issueTag->name }}
                            </h6>
                            @endforeach
                        </span>
                        <span class="d-flex flex-row-reverse mx-2 row-3 members-assigned">
                            @foreach (\App\User::join('assigned_user', 'user.id', '=',
                            'assigned_user.user_id')->where('assigned_user.issue_id', '=', $issue->id )->get() as
                            $assignee)
                            <span class="assignee ml-2" data-user-id={{ $assignee->id }}><img
                                    src="{{asset('assets/avatars/' . $assignee->photo_path . '.png')}}"
                                    alt="{{ $assignee->username }}" draggable="false" />
                            </span>
                            @endforeach
                        </span>
                    </span>
                </li>
                @endforeach
                <li class="add-item-li collapse" id="add-item-{{ $list->id }}">
                    <form class="add-item-form form-group">
                        <div class="form-group text-left">
                            <label for="item-title">Title</label>
                            <input type="text" class="form-control" class="item-title" placeholder="" />
                        </div>
                        <div class="d-flex justify-content-between">
                            <button type="submit" class="btn btn-primary add-item">Submit</button>
                            <button type="reset" class="btn btn-primary cancel-add-item">Cancel</button>
                        </div>
                    </form>
                </li>
            </ul>
        </div>
        @endforeach
        <!--end of backlog-->
    </div>
</section>

<!-- Delete list modal -->
<div class="modal fade" id="delete-list-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
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
                    This action will remove any cards and automation preset
                    associated with the column.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    Close
                </button>
                <button id="delete-list-button" type="button" data-dismiss="modal" class="btn btn-primary btn-danger">
                    Delete
                </button>
            </div>
        </div>
    </div>
</div>
</div>

<!-- Edit Task Modal -->
<div class="modal fade" id="edit-task-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Edit Note</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="recipient-name" class="col-form-label font-weight-bold">Label:</label>

                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    Close
                </button>
                <button id="edit-task-button" type="button" class="btn btn-primary" data-dismiss="modal">
                    Save Note
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Sidebar Issue -->
<div id="side-issue-container">
    <div id="side-issue" class="d-flex flex-column h-100 mx-3 py-3">
        <div id="side-issue-header" class="border-bottom mb-3">
            <div class="d-flex align-items-center">
                <h4 class="task-title mr-auto">HELLO</h4>
                <form class="edit-issue-title-form form-group d-none mr-auto">
                    <div class="form-group text-left">
                        <input type="text" class="form-control" id="new-task-title" placeholder="" />
                    </div>
                    <div class="d-flex justify-content-between">
                        <button type="submit" class="btn btn-primary edit-item-title btn">
                            Submit
                        </button>
                        <button type="reset" class="btn btn-primary edit-item-title-cancel">
                            Cancel
                        </button>
                    </div>
                </form>
                <button type="button" class="btn edit-task d-none mr-1">
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
            <h6 class="block pb-2 font-weight-bold">Assignees</h6>
            <ul class="assignees d-flex flex-wrap">
                <li>
                    <button id="add-assignee" type="button" class="custom-button add-button add-assignee">
                        <i class="fas fa-plus"></i>
                    </button>
                </li>
            </ul>
            <div id="add-new-assignee" class="d-none">
                <form id="write-assignee">
                    <input type="text" id="new-assignee" name="new-assignee" class="form-control"
                        placeholder="Type or choose an assignee..." />
                </form>
                <ul id="existing-users">
                    @foreach (\App\User::join('member_status', 'user.id', '=', 'member_status.user_id')
                    ->join('project', 'project.id', '=', 'member_status.project_id')
                    ->where('project.id', '=', $project->id)
                    ->select('user.id as id', 'user.username as username', 'photo_path')
                    ->groupBy('user.id')
                    ->get() as $assignee)
                    <li class="existing-user-container clickable d-flex flex-row align-items-center p-2"
                        data-user-id={{ $assignee->id }} data-username="{{ $assignee->username }}">
                        <i class="fas fa-check selected-user invisible mr-2"></i>
                        <span class="assignee ml-2"><img src="{{asset('assets/avatars/' . $assignee->photo_path . '.png')}}"
                                alt="{{ $assignee->username }}" draggable="false" />
                        </span>
                        <h6 class="mb-0 p-1 existing-user font-weight-bold ml-2">
                            {{ $assignee->username }}
                        </h6>
                    </li>
                    @endforeach
                </ul>
            </div>
        </div>
        <div class="labels-container mt-3">
            <h6 class="block pb-2 font-weight-bold">Labels</h6>
            <ul class="labels d-flex align-items-center flex-wrap">
                <li>
                    <button id="add-label" type="button" class="custom-button add-button add-label">
                        <i class="fas fa-plus"></i>
                    </button>
                </li>
            </ul>
            <div id="add-new-label" class="d-none">
                <form id="write-label">
                    <input type="text" id="new-label" name="new-label" class="form-control"
                        placeholder="Type or choose a label..." />
                </form>
                <ul id="existing-labels">
                    @foreach (\App\Tag::join('issue_tag', 'tag.id', '=', 'issue_tag.tag_id')
                    ->join('issue', 'issue_tag.issue_id', '=', 'issue.id')
                    ->join('issue_list', 'issue.issue_list_id', '=', 'issue_list.id')
                    ->where('issue_list.project_id', '=', $project->id)
                    ->select('tag.name as name', 'tag.id as id')
                    ->groupBy('tag.id')
                    ->get() as $issueTag)
                    <li class="existing-label-container clickable d-flex flex-row align-items-center p-2"
                        data-label-id={{ $issueTag->id }} data-label-name="{{ $issueTag->name }}">
                        <i class="fas fa-check invisible selected-label mr-2"></i>
                        <div class="color bg-info">
                        </div>
                        <h6 class="mb-0 p-1 existing-label">
                            {{ $issueTag->name }}
                        </h6>
                    </li>
                    @endforeach
                </ul>
            </div>

        </div>
        <div class="due-date-container mt-3">
            <h6 class="block pb-2 font-weight-bold">Due Date</h6>

            <button type="button" class="custom-button due-date-button" id="change-due-date">
                <i class="far fa-clock mr-2"></i><span id="due-date"></span>
            </button>

            <form id="select-due-date" class="mt-2 d-none">
                <span class="d-flex">
                    <input type="date" id="new-due-date" name="new-due-date" class="form-control" />
                    <button type="button" class="btn edit-task" id="submit-due-date">
                        <i class="far fa-save"></i>
                    </button>
                </span>
            </form>

        </div>
        <button id="delete-issue-button" type="button" class="custom-button close-button delete-issue mt-auto">
            Delete
        </button>
    </div>
</div>
@endsection