@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'none'])

@section('title', 'Kick | Report')

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
    <link rel="stylesheet" href="{{ asset('css/navbar.css') }}" />
    <link rel="stylesheet" href="{{ asset('css/reportuser.css') }}"/>
@endsection

@section('script')
    <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
    <script src="{{asset('js/index.js')}}" defer></script>
    @endsection


@section('content')

<div id="report-user-container" class="px-3">
    <h3
    id="user-report-title"
    class="title task-title pb-2 mt-5 mb-0 font-weight-bold"
    >
    Report a User
    </h3>
    <form id="report-user-form" class="py-4 p-3">
    <div class="row">
        <div class="form-group col-sm-12">
        <label for="user-reported" class="font-weight-bold"
            >User to Report</label
        >
        <input
            type="text"
            class="form-control"
            id="user-reported"
            placeholder="Enter a username"
        />
        <small id="reportHelp" class="form-text"
            >The report is completly anonymous.</small
        >
        </div>
        <div class="form-group col-sm-12">
        <label for="report-description" class="font-weight-bold"
            >Why are you reporting this user?</label
        >
        <textarea
            class="form-control"
            id="report-description"
            rows="3"
        ></textarea>
        </div>
        <div class="form-group col-sm-12">
        <label for="report-annexes" class="font-weight-bold"
            >Input any relevant file for the report analysis.</label
        >
        <div class="col-sm-6 pl-0">
            <div class="custom-file">
            <input type="file" class="custom-file-input" id="file02" />
            <label class="custom-file-label" for="file02"
                >Choose file</label
            >
            </div>
        </div>
        </div>
    </div>
    <div class="d-flex justify-content-end">
        <button id="submit-report" type="submit" class="btn btn-success">
        Submit
        </button>
    </div>
    </form>
    </div>
</div>

@endsection
<!--
    <script>
      let user_dropdown = document.querySelector(".user-dropdown");
      let notification_dropdown = document.querySelector(
        ".notification-dropdown"
      );

      document
        .querySelector(".notification")
        .addEventListener("click", function() {
          notification_dropdown.classList.toggle("d-none");
          if (!user_dropdown.classList.contains("d-none"))
            user_dropdown.classList.add("d-none");
        });

      document.querySelector(".user").addEventListener("click", function() {
        user_dropdown.classList.toggle("d-none");
        if (!notification_dropdown.classList.contains("d-none"))
          notification_dropdown.classList.add("d-none");
      });
    </script>
-->
