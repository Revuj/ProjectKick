@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'project'])

@section('title', 'Project_name | Issues Board')

@section('style')
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="{{asset('css/board.css')}}" />
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
    <script src="{{asset('js/board.js')}}" defer></script>
    <script src="{{asset('js/navbar.js')}}" defer></script>
    <script src="{{asset('js/index.js')}}" defer></script>
@endsection


@section('content')
<nav>
          <ol class="breadcrumb custom-separator">
            <li><a href="#0">lbaw</a></li>
            <li><a href="#0">Issues</a></li>
            <li class="current">Boards</li>
          </ol>
        </nav>
        <section
          class="board-options d-flex flex-row bd-highlight align-items-center"
        >
          <div id="filter-issues" class="py-3 my-0 flex-grow-1">
            <form class="d-flex justify-content-between">
              <div class="form-group mb-0 flex-grow-1 mx-2">
                <input
                  type="text"
                  class="form-control"
                  name="issues-filter"
                  id="issues-filter"
                  placeholder="Search or filter results..."
                />
              </div>
            </form>
          </div>
          <!-- create a new task-->
          <div class=" bd-highlight">
            <form id="add-list-form" class="input-group inputArea">
              <input
                type="text"
                class="form-control listCreated"
                placeholder="Add list"
              />
              <div class="input-group-append">
                <button class="btn btn-success add-list mr-1" type="button">
                  <i class="fa fa-plus"></i>
                </button>
              </div>
            </form>
          </div>
        </section>

        <section class="kanban-container mt-2">
          <div
            class="kanban-table d-flex flex-row bd-highlight align-items-begin"
          >
            <!--end of backlog-->
          </div>
        </section>

        <!-- Delete list modal -->
        <div
          class="modal fade"
          id="delete-list-modal"
          tabindex="-1"
          role="dialog"
          aria-labelledby="exampleModalLabel"
          aria-hidden="true"
        >
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Delete</h5>
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
                  This action will remove any cards and automation preset
                  associated with the column.
                </p>
              </div>
              <div class="modal-footer">
                <button
                  type="button"
                  class="btn btn-secondary"
                  data-dismiss="modal"
                >
                  Close
                </button>
                <button
                  id="delete-list-button"
                  type="button"
                  data-dismiss="modal"
                  class="btn btn-primary btn-danger"
                >
                  Delete
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Edit Task Modal -->
      <div
        class="modal fade"
        id="edit-task-modal"
        tabindex="-1"
        role="dialog"
        aria-labelledby="exampleModalLabel"
        aria-hidden="true"
      >
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLabel">Edit Note</h5>
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
                <div class="form-group">
                  <label
                    for="recipient-name"
                    class="col-form-label font-weight-bold"
                    >Label:</label
                  >
                  <input
                    type="text"
                    class="form-control"
                    id="edit-task-label"
                  />
                </div>
              </form>
            </div>
            <div class="modal-footer">
              <button
                type="button"
                class="btn btn-secondary"
                data-dismiss="modal"
              >
                Close
              </button>
              <button
                id="edit-task-button"
                type="button"
                class="btn btn-primary"
                data-dismiss="modal"
              >
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
              #1 Opened by Revuj
            </p>
          </div>
          <div class="assignees-container">
            <h6 class="block pb-2">Assignees</h6>
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
              <li>
                <button
                  type="button"
                  class="custom-button add-button add-assignee"
                >
                  <i class="fas fa-plus"></i>
                </button>
              </li>
            </ul>
          </div>
          <div class="labels-container">
            <h6 class="block">Labels</h6>
            <ul class="labels d-flex align-items-center">
              <li class="mr-2">
                <h6 class="mb-0 p-1 list-item-label bg-info">
                  Iteration 1
                </h6>
              </li>
              <li class="mr-2">
                <h6 class="mb-0 p-1 list-item-label bg-warning">
                  Iteration 2
                </h6>
              </li>
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
          <div class="due-date-container">
            <h6 class="block pb-2">Due Date</h6>

            <button type="button" class="custom-button due-date-button">
              <i class="far fa-clock mr-2"></i>Feb 29
            </button>
          </div>
          <button
            type="button"
            class="custom-button close-button delete-issue mt-auto"
          >
            Delete
          </button>
        </div>
      </div>
@endsection