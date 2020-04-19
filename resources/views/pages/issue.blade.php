@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true])

@section('title', 'Project_name | Issue_name')

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
@endsection


@section('content')
<div class="main-content-container px-4">
  <nav>
    <ol class="breadcrumb custom-separator">
      <li><a href="#0">lbaw</a></li>
      <li><a href="#0">Issues</a></li>
      <li class="current">#7</li>
    </ol>
  </nav>
  <div id="issue-container">
    <div id="issue" class="d-flex flex-column h-100 text-left">
      <div id="issue-header" class="mb-0 d-flex flex-column">
        <div class="d-flex align-items-center pt-2">
          <p class="mr-auto i smaller-text mb-0">
            <span class="bg-success text-light issue-status">Open</span>
            <span class="issue-status-description"
              >Opened 5 days ago by
              <span class="author-reference">Revuj</span></span
            >
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
          <h4 class="title task-title mr-auto mt-2">
            Hello, I'm a sexy Issue!
          </h4>
          <button
            type="button"
            class="custom-button edit-button edit-task mr-1"
          >
            <i class="ml-auto fas fa-pencil-alt float-right"></i>
          </button>
        </div>
        <ul class="labels smaller-text d-flex align-items-center">
          <li class="mr-2">
            <h6 class="label mb-0 px-1 list-item-label bg-info">
              Iteration 1
            </h6>
          </li>
          <li class="mr-2">
            <h6 class="label mb-0 px-1 list-item-label bg-warning">
              Iteration 2
            </h6>
          </li>
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
      <div class="row border-bottom my-4">
        <div class="col-md-9 description text-left">
          <p>
            Lorem ipsum dolor sit amet consectetur, adipisicing elit. Et
            deserunt velit, eligendi accusantium repellendus minima
            dolor quis blanditiis voluptatum fuga ab aperiam quaerat
            praesentium qui consequuntur possimus nihil, ipsum ea?
          </p>
        </div>
        <div
          class="col-md-3 members-and-duedate pb-3 d-flex flex-column justify-content-end ml-auto"
        >
          <div class="assignees-container ml-auto">
            <ul
              class="assignees d-flex align-items-center justify-content-center pb-3"
            >
              <li class="mr-2">
                <img
                  src="https://avatars3.githubusercontent.com/u/41621540?s=40&v=4"
                  alt="@vitorb19"
                  draggable="false"
                />
              </li>
              <li>
                <img
                  src="https://avatars2.githubusercontent.com/u/44231794?s=40&v=4"
                  alt="@vitorb19"
                  draggable="false"
                />
              </li>
            </ul>
          </div>
          <div class="due-date-container ml-auto">
            <button type="button" class="custom-button due-date-button">
              <i class="far fa-clock mr-2"></i>Feb 29
            </button>
          </div>
        </div>
      </div>
      <div class="add-comment-container mt-4">
        <form class="d-flex">
          <img
            class="comment-author"
            src="https://assets-br.wemystic.com.br/20191112193725/bee-on-flower_1519375600-960x640.jpg"
            alt=""
          />
          <input
            class="w-100 mx-2 px-2"
            type="text"
            name="comment"
            id="new-comment"
            placeholder="Write a comment..."
          />
        </form>
      </div>
      <div class="comments-container">
        <div class="comment d-flex border-bottom mt-4 pb-1">
          <img
            class="comment-author"
            src="https://avatars3.githubusercontent.com/u/41621540?s=40&v=4"
            alt=""
          />
          <div class="comment-detail ml-3">
            <h6>
              <span class="author-reference">Revuj</span>
              <span class="comment-timestamp ml-1">just now...</span>
            </h6>
            <p>
              Good job Abelha!
            </p>
          </div>
          <div class="karma ml-auto mr-3 d-flex flex-column">
            <i class="fas fa-chevron-up"></i>
            <p class="mb-0 text-center">1</p>
            <i class="fas fa-chevron-down"></i>
          </div>
        </div>
        <div class="comment d-flex border-bottom mt-4 pb-1">
          <img
            class="comment-author"
            src="https://assets-br.wemystic.com.br/20191112193725/bee-on-flower_1519375600-960x640.jpg"
            alt=""
          />
          <div class="comment-detail ml-3">
            <h6>
              <span class="author-reference">Abelha</span>
              <span class="comment-timestamp ml-1">3 hours ago</span>
            </h6>
            <p>
              Almost Done...
            </p>
          </div>
          <div class="karma ml-auto mr-3 d-flex flex-column">
            <i class="fas fa-chevron-up text-info"></i>
            <p class="mb-0 text-center">2</p>
            <i class="fas fa-chevron-down"></i>
          </div>
        </div>
        <div class="comment d-flex border-bottom mt-4 pb-1">
          <img
            class="comment-author"
            src="https://avatars2.githubusercontent.com/u/44231794?s=40&v=4"
            alt=""
          />
          <div class="comment-detail ml-3">
            <h6>
              <span class="author-reference">Vator</span>
              <span class="comment-timestamp ml-1">2 weeks ago</span>
            </h6>
            <p>
              Hey guys I opened this issue but will never work on it.
            </p>
            <p>
              Good Luck!
            </p>
          </div>
          <div class="karma ml-auto mr-3 d-flex flex-column">
            <i class="fas fa-chevron-up"></i>
            <p class="mb-0 text-center">1</p>
            <i class="fas fa-chevron-down"></i>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
@endsection
