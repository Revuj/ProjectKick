@extends('layouts.app', ['hide_navbar' => true, 'hide_footer' => false, 'sidebar' => 'none'])

@section('title', 'Kick')

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
    <link rel="stylesheet" href="{{ asset('css/auth.css') }}" />
    <link rel="stylesheet" href="{{ asset('css/main.css') }}"/>
@endsection

@section('script')
    <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
    <script src="{{asset('js/index.js')}}" defer></script>
@endsection


@section('content')
    <!-- Navbar custom for this page -->
    <nav id="main-nav" class="navbar navbar-expand-lg navbar-light">
        <a class="navbar-brand ml-4" href="#">
        <h4><i class="fas fa-drafting-compass"></i> Kick</h4>
        </a>
        <button
        class="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent"
        aria-expanded="false"
        aria-label="Toggle navigation"
        >
        <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
            <!-- <li class="nav-item active">
            <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">Link</a>
        </li>
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Dropdown
            </a>
            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
            <a class="dropdown-item" href="#">Action</a>
            <a class="dropdown-item" href="#">Another action</a>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item" href="#">Something else here</a>
            </div>
        </li>
        <li class="nav-item">
            <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
        </li> -->
        </ul>
        <span class="mt-2 mr-4">
            <label id="switch" class="switch">
            <input type="checkbox" onchange="toggleTheme()" id="slider">
            <span class="slider round"></span>
        </span>
        <a href="/login" class="btn mr-4">Login</a>
        <a href="/register" class="btn mr-4">Signup</a>
        </div>
    </nav>

    <!-- Jumbotron -->
    <div id="preview" class="jumbotron mb-5">
        <div class="container">
        <div class="row">
            <div id="description" class="col-md-12 text-center">
            <h1 class="display-4">
                Work smarter with
                <span class="display-4 font-weight-bold" id="main-title"
                >Project Kick</span
                >
            </h1>
            <p class="lead">
                Project Kick will enable your team to create its own workflow,
                plan ahead and monitorize their work progress effortlessly.
            </p>
            <hr class="my-4" />
            <form
                class="container text-center col-md-12"
                action="{{ route('register') }}"
            >
                <div class="form-group row justify-content-center">
                <input
                    name="email"
                    class="form-control-lg col-md-8 mb-1"
                    type="email"
                    placeholder="Email"
                />
                <button
                    type="submit"
                    data-analytics-event="clickedSignupHeroButton"
                    class="btn-wrap btn-lg col-md-3 btn ml-auto mb-1"
                >
                    Sign Up!
                </button>
                </div>
            </form>
            </div>
        </div>
        </div>
    </div>

    <section id="main-page-body">
        <div class="container py-6 pb-md-0 mt-5">
        <div class="row justify-content-around align-items-center">
            <div class="col-md-7 order-md-12 px-0">
            <div
                id="carouselExampleFade"
                class="carousel slide carousel-fade mb-3"
                data-ride="carousel"
            >
                <div class="carousel-inner">
                <div class="carousel-item active">
                    <img
                    src="./assets/svg/undraw_quiz_nlyh.svg"
                    class="d-block w-100 max-300"
                    alt="..."
                    />
                </div>
                <div class="carousel-item">
                    <img
                    src="./assets/svg/undraw_scrum_board_cesn.svg"
                    class="d-block w-100 max-300"
                    alt="..."
                    />
                </div>
                </div>
            </div>
            </div>
            <div class="col-md-5 order-md-1 text-center text-md-left">
            <h3>Organize your workflow</h3>
            <p>
                Whether you're a student, professional, or just want to feel in
                control of your actions, our task lists are the right ones for
                you!
            </p>
            <p>
                <a href="/register" class="custom-button primary-button px-3 mt-2">Start now →</a>
            </p>
            </div>
        </div>
        </div>

        <div class="container py-5 pb-md-0">
        <div class="row align-items-center">
            <div class="col-md-7 order-md-12 px-0">
            <div
                id="carouselExampleFade"
                class="carousel slide carousel-fade mb-3"
                data-ride="carousel"
            >
                <div class="carousel-inner">
                <div class="carousel-item active">
                    <img
                    src="./assets/svg/undraw_work_chat_erdt.svg"
                    class="d-block w-100 max-300"
                    alt="..."
                    />
                </div>
                <div class="carousel-item">
                    <img
                    src="./assets/svg/undraw_ask_me_anything_k8o0.svg"
                    class="d-block w-100 max-300"
                    alt="..."
                    />
                </div>
                </div>
            </div>
            </div>
            <div class="col-md-5 order-md-12 text-center text-md-left">
            <h3>Communicate your ideas</h3>
            <p>
                With Project Kick you can not only comment the various cards
                placed on your project's boards but also make use of our built-in
                chat where you can discuss your thoughts with your team.
            </p>
            <p>
                <a href="/register" class="custom-button primary-button px-3 mt-2">Start now →</a>
            </p>
            </div>
        </div>
        </div>

        <div class="container py-5 pb-0">
        <div class="row align-items-center">
            <div class="col-md-7 order-md-12 px-0">
            <div
                id="carouselExampleFade"
                class="carousel slide carousel-fade mb-3"
                data-ride="carousel"
            >
                <div class="carousel-inner">
                <div class="carousel-item active">
                    <img
                    src="./assets/svg/undraw_project_completed_w0oq.svg"
                    class="d-block w-100 max-300"
                    alt="..."
                    />
                </div>
                <div class="carousel-item">
                    <img
                    src="./assets/svg/undraw_browsing_urt9.svg"
                    class="d-block w-100 max-300"
                    alt="..."
                    />
                </div>
                <div class="carousel-item">
                    <img
                    src="./assets/svg/undraw_progress_data_4ebj.svg"
                    class="d-block w-100 max-300"
                    alt="..."
                    />
                </div>
                </div>
            </div>
            </div>
            <div class="col-md-5 order-md-1 text-center text-md-left">
            <h3>Track your progress</h3>
            <p>
                We keep track of your team's actions in every project, so you can
                analyze how your project is growing and your teammates influence
                on it.
            </p>
            <p>
                <a href="/register" class="custom-button primary-button px-3 mt-2">Start now →</a>
            </p>
            </div>
          </div>
        </div>
    </section>

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

@endsection
