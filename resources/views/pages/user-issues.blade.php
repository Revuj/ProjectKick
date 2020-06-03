@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'user'])

@section('title', 'Assigned Issues')

@section('style')
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
<link rel="stylesheet" href="{{asset('css/my_work.css')}}" />
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
<script src="{{asset('js/my_work.js')}}" defer></script>
<script src="{{asset('js/navbar.js')}}" defer></script>
<script src="{{asset('js/index.js')}}" defer></script>
@endsection


@section('content')
<div class="main-content-container px-4">

    <nav>
        <ol class="breadcrumb custom-separator">
            <li class="current">My Work</li>
        </ol>
    </nav>
    <div id="tables-types" class="d-flex border-bottom nav-links pb-2">
        <li class="active">
            Today
        </li>
        <li>Upcoming </li>
    </div>

    <ul id="today" class="issue-list mx-2">

        @foreach($issues as $issue)
        @php
        $date1 =\Carbon\Carbon::parse($issue->due_date);
        @endphp
        @if ($issue->due_date !== NULL && $date1->eq($today) )
        <li class="issue open px-2 border-bottom">
            <div class="issue-header d-flex align-items-center">
                <a href="/issues/{{$issue->id}}" class="task-title nostyle title">{{ $issue->name }}</a>

                <div class="due-date-container text-right">
                    <i class="fas fa-calendar-alt mx-2"></i>
                    @if ($issue->due_date === NULL)
                    Not defined
                    @else
                    {{ date_format(date_create($issue->due_date), 'jS F Y')}}
                    @endif

                </div>

            </div>
            <div class="d-flex issue-status mt-1">
                <p>
                    #{{$issue->id}}
                    <span class="open-description">Opened
                        {{ date_format(date_create($issue->creation_date), 'jS F Y')}}</span>
                </p>
                <div class="assignees-container ml-auto text-center">
                    <ul class="assignees d-flex "></ul>
                </div>
            </div>
        </li>
        @endif
        @endforeach
    </ul>

    <ul id="upcoming" class="issue-list d-none mx-2">

        @foreach($issues as $issue)
        @php
        $date1 =\Carbon\Carbon::parse($issue->due_date);
        @endphp
        @if ( $issue->due_date === NULL || $date1 ->gt($today) )
        <li class="issue open px-2 border-bottom">
            <div class="issue-header d-flex align-items-center">
                <a href="/issues/{{$issue->id}}" class="task-title nostyle title">{{ $issue->name }}</a>

                <div class="due-date-container text-right">
                    <i class="fas fa-calendar-alt m-2"></i>
                    @if ($issue->due_date === NULL)
                    Not defined
                    @else
                    {{ date_format(date_create($issue->due_date), 'jS F Y')}}
                    @endif

                </div>

            </div>
            <div class="d-flex issue-status mt-1">
                <p>
                    #{{$issue->id}}
                    <span class="open-description">Opened
                        {{ date_format(date_create($issue->creation_date), 'jS F Y')}}</span>
                </p>
                <div class="assignees-container ml-auto text-center">
                    <ul class="assignees d-flex "></ul>
                </div>
            </div>
        </li>
        @endif
        @endforeach

    </ul>

    <div class="modal" id="addTaskModal" tabindex="-1" role="dialog" aria-labelledby="addTaskModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addTaskModalLabel">Add Task</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="form-row">
                            <div class="col">
                                <label for="project-name" class="col-form-label">Select Project</label>
                                <input type="text" class="form-control" id="project-name" />
                            </div>
                            <div class="col d-none">
                                <label for="task-list" class="col-form-label">Task List</label>
                                <input type="text" class="form-control" id="task-list" />
                            </div>
                        </div>
                        <div class="form-group mt-4">
                            <input type="text" class="form-control" id="task-name"
                                placeholder="What needs to be done?" />
                        </div>
                        <div class="form-row">
                            <div class="col">
                                <label for="task-assignment" class="col-form-label">Who should do this?</label>
                                <input type="text" class="form-control" id="task-assignment" />
                            </div>
                            <div class="col">
                                <label for="task-due-date" class="col-form-label">Due Date</label>
                                <input type="date" class="form-control" id="task-due-date" />
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn " data-dismiss="modal">
                        Close
                    </button>
                    <button type="button" class="btn btn-success">
                        Add Task
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection