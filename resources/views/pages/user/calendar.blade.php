@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'user', 'user' => $user_id])

@section('title', 'Calendar')

@section('style')
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="{{asset('css/calendar.css')}}" />
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
    <script src="{{asset('js/calendar.js')}}" defer></script>
    <script src="{{asset('js/navbar.js')}}" defer></script>
    <script src="{{asset('js/index.js')}}" defer></script>
@endsection

@section('content')
<div class="main-content-container px-4" id="calendar">
  <nav>
    <ol class="breadcrumb custom-separator">
      <li class="current">Calendar</li>
    </ol>
  </nav>
  <div class="align-items-end w-100 d-flex">
    <button
      type="button"
      data-toggle="modal"
      data-target="#addEventModal"
      class="btn btn-success ml-auto"
    >
      <i class="fa fa-plus-circle fa-lg"></i>
      <span>Add Event</span>
    </button>
  </div>

  <div class="my-2" id="calendar-content" data-user="{{ $user_id }}">
    <div class="row container-fluid mx-0 px-0">
      <!--=============================ADD & CHECK EVENTS ================================================//-->
      <div
        class="col-md-4 col-sm-8 event-manager p-0 d-flex flex-column"
      >
        <div class="current-day text-center py-4 white-text">
          <h1 class="calendar-left-side-day"></h1>
          <div class="calendar-left-side-day-of-week"></div>
        </div>
        <div class="current-day-events text-left px-4 white-text py-4">
          <div class="h5 mb-3">Current Events:</div>
          <ul class="current-day-events-list"><li>"oi</li></ul>
        </div>
      </div>
      <!-- first col-->

      <!--============================= BROWSE THE CALENDAR ================================================//-->

      <div class="col col-md-8 col-sm-4 calendar-content">
        <div class="text-right calendar-change-year p-3">
          <div class="calendar-change-year-slider">
            <span
              class="fa fa-caret-left cursor-pointer calendar-change-year-slider-prev clickable"
            ></span>
            <span class="calendar-current-year px-2"></span>
            <span
              class="fa fa-caret-right cursor-pointer calendar-change-year-slider-next clickable"
            ></span>
          </div>
        </div>
        <div class="calendar-month-list">
          <ul
            class="calendar-month d-flex justify-content-between flex-wrap"
          ></ul>
        </div>

        <table class="table table-borderless">
          <thead class="calendar-week-list"></thead>
          <tbody class="calendar-days-list"></tbody>
        </table>
      </div>
      <!-- second col-->
    </div>
  </div>
  <div
    class="modal"
    id="addEventModal"
    tabindex="-1"
    role="dialog"
    aria-labelledby="addEventModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="addEventModalLabel">
            Add Event
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
          <form>
            <div class="form-group">
              <label for="event-name" class="col-form-label"
                >Event Name</label
              >
              <input type="text" class="form-control" id="event-name" />
            </div>
            <div class="form-group">
              <div class="btn-group" data-toggle="buttons">
                <label class="btn btn-outline-primary">
                  <input type="radio" name="options" id="option1" />
                  Meeting
                </label>
                <label class="btn btn-outline-primary">
                  <input type="radio" name="options" id="option2" />
                  Personal
                </label>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn " data-dismiss="modal">
            Close
          </button>
          <button type="button" class="btn btn-success" id="add-event">
            Add Event
          </button>
        </div>
      </div>
    </div>
  </div>
</div>
@endsection
