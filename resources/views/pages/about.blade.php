@extends('layouts.app', ['hide_navbar' => true, 'hide_footer' => true, 'sidebar' => 'none'])

@section('title', 'Kick | About us')

@section('style')
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="{{asset('css/main.css')}}" />
@endsection

@section('script')
  <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
    integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
    crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
    integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
    crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
    integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
    crossorigin="anonymous"></script>
    <script src="{{asset('js/index.js')}}" defer></script>
@endsection


@section('content')
    <nav id="main-nav" class="navbar navbar-expand-lg navbar-light">
      <a class="navbar-brand ml-4" href="/">
        <h4><i class="fas fa-drafting-compass"></i> Kick</h4>
      </a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
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
    <div>
      <!-- Jumbotron -->
      <div id="preview" class="jumbotron mb-5">
        <div class="container">
          <div class="row">
            <div id="description" class="col-md-12 text-center">
              <h1 class="font-weight-bold title" id="about-title">
                About ProjectKick
              </h1>
              <p class="lead">
                Learn more about us, where we came from, and where we're headed
              </p>
            </div>
          </div>
        </div>
      </div>
      <div class="main-container">
        <div class="main-content-container">
          <div id="tables-types" class="d-flex nav-links justify-content-center mb-3">
            <li >
              <a href="#about-us" class="nostyle">About us</a>
            </li>
            <li><a href="#the-team" class="nostyle">The team</a></li>
          </div>
          <div id="about-us">
            <h3 class="font-weight-bold mb-3 title">About Us</h3>
            <div id="about-text" class="text-justify">
              <p class="mb-3">
                In a world where the majority of the development comes from maintaining and building projects, having a
                tool where everything can be managed is now one of the key elements in projects, playing an important
                role in its organization and success.
              </p>
              <p>
                Through this application, users, within teams, can create customizable lists for their tasks and issues
                with items that can be moved through different lists and have an overview of the lists through a
                representation in the form of a table or a Kanban board. For each task and issue it will be possible to
                assign them to a team member, define their due date, label them and search using different filters. The
                tasks and issues can also be commented by any team member, and, if that's not enough, users can also
                communicate through discussion forums for each project. It is worth noticing that every user activity,
                such as defining new tasks or completing them, will be registered so the team can track their progress.
                With innovative thinking, a user friendly design, an efficient task management and a ground breaking
                discussion forum, this all in one application can go up against the already established companies in
                this business.
              </p>
            </div>
          </div>

          <div id="the-team">
            <h3 class="font-weight-bold mb-3 title">The Team</h3>
            <div id="team-text" class="text-justify">
              <p>
                We are a small college group of portuguese students, studying Informatics and Computation Engineering and FEUP (Faculty of Engineering of University of Porto), and we are motivated to build a tool that other students can make use of, where everything they need to manage their project is in the same application!
              </p>
            </div>
            <div id="team-members" class="row container-fluid">
              <div class="col-md-6 pl-0 pr-1 py-2">
                <div class="team-member">
                  <div class="team-member-header d-flex">
                    <div class="notify_img">
                      <img src="https://assets-br.wemystic.com.br/20191112193725/bee-on-flower_1519375600-960x640.jpg" alt="profile_pic" style="width: 100px; height: 100px">
                    </div>
                    <div class="ml-4 text-left">
                      <h6 class="mb-2 font-weight-bold">João Abelha</h6>
                      <p>Tall bearded guy.</p>
                      <p>"My back hurts..."</p>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-md-6 pr-0 py-2">
                <div class="team-member">
                  <div class="team-member-header d-flex">
                    <div class="notify_img">
                      <img src="https://avatars2.githubusercontent.com/u/41621540?s=460&u=d7ff47d25be54955bd53f039f45b24049c121395&v=4" alt="profile_pic" style="width: 100px; height: 100px">
                    </div>
                    <div class="ml-4 text-left">
                      <h6 class="mb-2 font-weight-bold">João Varela</h6>
                      <p>Handsome young man.</p>
                      <p>"My back hurts..."</p>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-md-6 pl-0 pr-1 py-2">
                <div class="team-member">
                  <div class="team-member-header d-flex">
                    <div class="notify_img">
                      <img src="./assets/profile.png" alt="profile_pic" style="width: 100px; height: 100px">
                    </div>
                    <div class="ml-4 text-left">
                      <h6 class="mb-2 font-weight-bold">Vator Barbosa</h6>
                      <p>Small guy that uses the train a lot.</p>
                      <p>"Tenho de mudar a letra nas páginas."</p>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-md-6 pr-0 py-2">
                <div class="team-member">
                  <div class="team-member-header d-flex">
                    <div class="notify_img">
                      <img src="./assets/profile.png" alt="profile_pic" style="width: 100px; height: 100px">
                    </div>
                    <div class="ml-4 text-left">
                      <h6 class="mb-2 font-weight-bold">Manuel Moreira</h6>
                      <p>Anselmo's brother.</p>
                      <p>"Tenho de trabalhar mais!"</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        <h3 class="font-weight-bold mt-5 mb-3 title">Still have questions about ProjectKick?</h3>
        <button id="get-in-touch" class="custom-button secondary-button"><a href="/contact" class="nostyle">Get in touch</a></button>
        </div>
      </div>
      <footer>
        <div class="d-flex justify-content-around align-items-center footer-content">
          <p class="p-3 m-0">
            &#x00A9 2020 Project Kick
          </p>
          <p class="p-3 m-0">
            <a href="/about">
              About
            </a>
          </p>
          <p class="p-3 m-0">
            <a href="/contact">
              Contact Us
            </a>
          </p>
        </div>
      </footer>
    </div>
  </div>
@endsection
