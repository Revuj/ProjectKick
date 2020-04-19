@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true])

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
            <li class="active">
              Today <span class="tables-type-counter">2</span>
            </li>
            <li>This week <span class="tables-type-counter">3</span></li>
            <li>This Month <span class="tables-type-counter">3</span></li>
            <li>All <span class="tables-type-counter">332</span></li>
          </div>
          <!--end of fiters-->

          <!--history-->
          <div id="history">
            <div class="timeline-body mt-4">
              <div class="timeline-item">
                <p class="time">Now</p>
                <div class="content">
                  <div
                    class="d-flex justify-content-between align-items-center"
                  >
                    <div class="title text-left">
                      Normalize database
                    </div>
                    <div class="time-mobile">
                      Now
                    </div>
                  </div>

                  <p class="text-left">
                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Est
                    illum, harum iusto quaerat accusamus quis odio a asperiores,
                    enim delectus, ea veritatis itaque architecto nisi!
                  </p>
                  <p class="author text-right p-2">
                    <span class="status open bg-success">Opened</span> by
                    <span class="author-reference text-right">Vator</span>
                  </p>
                </div>
              </div>

              <div class="timeline-item">
                <p class="time">5 min</p>
                <div class="content">
                  <div
                    class="d-flex justify-content-between align-items-center"
                  >
                    <div class="title text-left">
                      Finish Design
                    </div>
                    <div class="time-mobile">
                      Now
                    </div>
                  </div>

                  <p class="text-left">
                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Est
                    illum, harum iusto quaerat accusamus quis odio a asperiores,
                    enim delectus, ea veritatis itaque architecto nisi!
                  </p>
                  <p class="author text-right p-2">
                    <span class="status open bg-success">Opened</span> by
                    <span class="author-reference text-right">Revuj</span>
                  </p>
                </div>
              </div>
              <div class="timeline-item">
                <p class="time">Now</p>
                <div class="content">
                  <div
                    class="d-flex justify-content-between align-items-center"
                  >
                    <div class="title text-left">
                      Deliver a2
                    </div>
                    <div class="time-mobile">
                      3 h
                    </div>
                  </div>

                  <p class="text-left">
                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Est
                    illum, harum iusto quaerat accusamus quis odio a asperiores,
                    enim delectus, ea veritatis itaque architecto nisi!
                  </p>
                  <p class="author text-right p-2">
                    <span class="status closed bg-danger">Closed</span> by
                    <span class="author-reference text-right">Abelha</span>
                  </p>
                </div>
              </div>
              <div class="timeline-item">
                <p class="time">Now</p>
                <div class="content">
                  <div
                    class="d-flex justify-content-between align-items-center"
                  >
                    <div class="title text-left">
                      Deliver a2
                    </div>
                    <div class="time-mobile">
                      Now
                    </div>
                  </div>

                  <p class="text-left">
                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Est
                    illum, harum iusto quaerat accusamus quis odio a asperiores,
                    enim delectus, ea veritatis itaque architecto nisi!
                  </p>
                  <p class="author text-right p-2">
                    <span class="status open bg-info">Commented</span>
                    by
                    <span class="author-reference text-right">Vator</span>
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>

@endsection
