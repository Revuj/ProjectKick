@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'project'])

@section('title', 'Kick | Project Activity')

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
    <script src="{{asset('js/activity.js')}}" defer></script>

    
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
    <link rel="stylesheet" href="{{ asset('css/activity.css') }}" />
    <link rel="stylesheet" href="{{ asset('css/navbar.css') }}"/>
@endsection

@section('content')
<div class="main-content-container px-4">
          <nav>
            <ol class="breadcrumb custom-separator">
              <li><a href="#0">lbaw</a></li>
              <li><a href="#0">Project Overview</a></li>
              <li class="current">Activity</li>
            </ol>
          </nav>

          <!--filters-->
          <div id="tables-types" class="d-flex border-bottom nav-links">
            <li data-target = "created-issues" class="active">Created issues <span class="tables-type-counter mx-1">{{count($creation_issues)}}</span></li>
            <li data-target = "closed-issues"> Closed issues <span class="tables-type-counter mx-1">{{count($closed_issues)}}</span></li>
            <li data-target = "comments"> Comments <span class="tables-type-counter mx-1">{{count($comments)}}</span></li>
            <li data-target = "channels"> Channels <span class="tables-type-counter mx-1">{{count($channels)}}</span></li>
            <li data-target = "all">All <span class="tables-type-counter mx-1">{{count($activity)}}</span></li>
          </div>
          <!--end of fiters-->

          <!--history-->
          <div id="history">
            <div class="timeline-body mt-4">

              <div id="created-issues" class = "active">
                @foreach($creation_issues as $elem)
                  @include('partials.Activity.created_issues', $elem)
                @endforeach

                @include('partials.Activity.info_project', [$project, $author]);
              </div>

              <div id = "closed-issues" class = "d-none">
                @foreach($closed_issues as $elem)
                  @include('partials.Activity.closed_issues', $elem)
                @endforeach

                @include('partials.Activity.info_project', [$project, $author]);
              </div>

              <div id = "comments" class = "d-none">
                @foreach($comments as $elem)
                  @include('partials.Activity.comments', $elem)
                @endforeach

                @include('partials.Activity.info_project', [$project, $author]);
              </div>

              <div id="channels" class = "d-none">
                @foreach($channels as $elem)
                  @include('partials.Activity.channel', $elem)
                @endforeach

                @include('partials.Activity.info_project', [$project, $author]);
              </div>

              <div id="all" class = "d-none">
                @foreach($activity as $elem)

                  @if ($elem['type'] === 'create_issues')
                    @include('partials.Activity.created_issues', $elem)

                  @elseif($elem['type'] === 'close_issues')
                    @include('partials.Activity.closed_issues', $elem)

                  @elseif($elem['type'] === 'comment')
                    @include('partials.Activity.comments', $elem)

                  @elseif($elem['type'] === 'channel') 
                    @include('partials.Activity.channel', $elem)

                  @endif             

                @endforeach

                @include('partials.Activity.info_project', [$project, $author]);
              </div>

          </div>
        </div>

@endsection
